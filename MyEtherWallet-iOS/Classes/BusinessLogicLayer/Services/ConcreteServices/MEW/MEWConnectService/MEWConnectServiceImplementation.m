//
//  MEWConnectServiceImplementation.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 24/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import CocoaLumberjack;
@import SocketIO;
@import libextobjc.EXTScope;
@import WebRTC;

#import "MyEtherWallet_iOS-Swift.h"

#import "NetworkingConstantsHeader.h"
#import "ResponseMapper.h"

#import "MEWConnectConstants.h"
#import "NSString+HexData.h"
#import "NSData+SECP256K1.h"
#import "NSData+Hexadecimal.h"

#import "MEWRTCService.h"
#import "MEWRTCServiceDelegate.h"

#import "MEWConnectServiceImplementation.h"

#import "MEWConnectCommand.h"

static const int ddLogLevel = DDLogLevelVerbose;

static NSTimeInterval kMEWConnectServiceTimeoutInterval = 10.0;

@interface MEWConnectServiceImplementation () <NSURLSessionDelegate, MEWRTCServiceDelegate>
@property (nonatomic, strong) NSString *connectionId;
@property (nonatomic, strong) NSString *privateKey;
@property (nonatomic, strong) SocketManager *socketManager;
@property (nonatomic) MEWConnectStatus connectionStatus;
@property (nonatomic) dispatch_source_t timeoutTimer;
@end

@implementation MEWConnectServiceImplementation
@synthesize delegate = _delegate;

#pragma mark - LifeCycle

- (instancetype) initWithMapper:(id<ResponseMapper>)mapper {
  self = [super init];
  if (self) {
    _messageMapper = mapper;
  }
  return self;
}

- (void)dealloc {
  [self disconnect];
}

#pragma mark - Public

- (BOOL) connectWithData:(NSString *)data {
  if (self.connectionStatus != MEWConnectStatusDisconnected) {
    [self disconnect];
  }
  NSArray *params = [data componentsSeparatedByString:@"_"];
  if ([params count] < 2) {
    return NO;
  }
  self.connectionId = [params lastObject];
  self.privateKey = [params firstObject];
  if (!self.connectionId || !self.privateKey ||
      [self.connectionId length] == 0 || [self.privateKey length] == 0) {
    return NO;
  }
  NSURL *url = [NSURL URLWithString:MEWConnectServiceSignallingServerURL];
  if (!url) {
    return NO;
  }
  self.socketManager = [[SocketManager alloc] initWithSocketURL:url config:[self _socketConfig]];
  SocketIOClient *client = [self.socketManager defaultSocket];
  [self _defineSignalsWithSocketClient:client];
  [client connect];
  [self _createTimeoutTimer];
  self.connectionStatus = MEWConnectStatusConnecting;
  return YES;
}

- (void)disconnect {
  self.connectionStatus = MEWConnectStatusDisconnected;
  [self.rtcService disconnect];
  [self.socketManager disconnect];
  self.socketManager = nil;
  [self _cancelTimeoutTimer];
}

- (BOOL)sendMessage:(id)message {
  NSDictionary *context = @{kMappingContextModelClassKey: NSStringFromClass([message class])};
  NSError *error = nil;
  id serializedMessage = [self.messageMapper serializeResponse:message withMappingContext:context error:&error];
  if (error) {
    DDLogWarn(@"Error: %@", error);
    return NO;
  }
  return [self.rtcService sendMessage:serializedMessage];
}

#pragma mark - NSURLSessionDelegate

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler {
  completionHandler(NSURLSessionAuthChallengeUseCredential, [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust]);
}

#pragma mark - Private

- (NSDictionary *) _socketConfig {
  return @{kMEWConnectSocketConfigLog             : @NO,
           kMEWConnectSocketConfigCompress        : @YES,
           kMEWConnectSocketConfigSecure          : @YES,
           kMEWConnectSocketConfigSelfSigned      : @YES,
           kMEWConnectSocketConfigSessionDelegate : self,
           kMEWConnectSocketConfigConnectParams   : @{
               kMEWConnectSocketConfigConnId      : self.connectionId,
               kMEWConnectSocketConfigKey         : self.privateKey,
               kMEWConnectSocketConfigStage       : MEWConnectSocketReceiver}
           };
}

- (void) _defineSignalsWithSocketClient:(SocketIOClient *)client {
  @weakify(self);
  /* Connect signal */
  [client on:kMEWConnectSignalConnect callback:^(NSArray* data, SocketAckEmitter* ack) {
    @strongify(self);
    [self _signalConnect:data];
  }];
  
  /* Handshake signal */
  [client on:kMEWConnectSignalHandshake callback:^(NSArray *data, SocketAckEmitter *ack) {
    @strongify(self);
    [self _signalHandshake:data];
  }];
  
  
  /* Offer signal */
  [client on:kMEWConnectSignalOffer callback:^(NSArray *data, SocketAckEmitter *emit) {
    @strongify(self);
    [self _signalOffer:data];
  }];
  
  /* Answer signal */
  [client on:kMEWConnectSignalAnswer callback:^(NSArray *data, SocketAckEmitter *emit) {
    @strongify(self);
    [self _signalAnswer:data];
  }];
  
  /* Error signal */
  [client on:kMEWConnectSignalError callback:^(NSArray * data, SocketAckEmitter * emit) {
    @strongify(self);
    [self _signalError:data];
  }];
  
  /* Invalid connection signal */
  [client on:kMEWConnectSignalInvalidConnection callback:^(NSArray * data, SocketAckEmitter * emit) {
    @strongify(self);
    [self _signalError:nil];
  }];
  
  /* Any signal */
  [client onAny:^(SocketAnyEvent * _Nonnull event) {
    @strongify(self);
    [self _signalAny:event];
  }];
}

- (void) _emit:(NSString *)emit message:(id)message {
  DDLogVerbose(@"MEWConnect: emit message: %@", emit);
  SocketIOClient *client = [self.socketManager defaultSocket];
  [client emit:emit with:@[message]];
  [self _createTimeoutTimer];
}

- (void) _timeout {
  [self disconnect];
  if ([self.delegate respondsToSelector:@selector(MEWConnectDidDisconnectedByTimeout:)]) {
    [self.delegate MEWConnectDidDisconnectedByTimeout:self];
  }
}

- (void) _createTimeoutTimer {
  [self _cancelTimeoutTimer];
  dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
  self.timeoutTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
  uint64_t interval = (uint64_t) (kMEWConnectServiceTimeoutInterval * NSEC_PER_SEC);
  dispatch_source_set_timer(self.timeoutTimer,
                            dispatch_time(DISPATCH_TIME_NOW, interval),
                            interval,
                            (1ull * NSEC_PER_SEC) / 10);
  @weakify(self);
  dispatch_source_set_event_handler(self.timeoutTimer, ^{
    @strongify(self)
    dispatch_async(dispatch_get_main_queue(), ^{
      [self _timeout];
    });
  });
  dispatch_resume(self.timeoutTimer);
}

- (void) _cancelTimeoutTimer {
  if (self.timeoutTimer != nil) {
    dispatch_source_cancel(self.timeoutTimer);
    self.timeoutTimer = nil;
  }
}

#pragma mark - Signals

- (void) _signalConnect:(NSArray *)data {
  DDLogVerbose(@"MEWConnect: connected");
}

- (void) _signalHandshake:(NSArray *)data {
  DDLogVerbose(@"MEWConnect: handshake");
  
  NSString *toSign = [data firstObject][kMEWConnectSocketToSign];
  if (toSign) {
    NSData *toSignHashData = [Web3Wrapper hashWithData:[toSign dataUsingEncoding:NSUTF8StringEncoding]];
    NSData *privateKeyData = [self.privateKey parseHexData];
    
    NSData *signedData = [toSignHashData signWithPrivateKeyData:privateKeyData];
    NSString *signedMessage = [signedData hexadecimalString];
    if (signedMessage) {
      NSDictionary *message = @{kMEWConnectMessageSigned: signedMessage,
                                kMEWConnectMessageConnId: self.connectionId};
      [self _emit:kMEWConnectEmitSignature message:message];
    }
  }
}

- (void) _signalOffer:(NSArray *)data {
  DDLogVerbose(@"MEWConnect: offer");
  NSString *offerDataString = [data firstObject][@"data"];
  NSDictionary *offer = [[NSJSONSerialization JSONObjectWithData:[offerDataString dataUsingEncoding:NSUTF8StringEncoding]
                                                         options:0
                                                           error:nil] firstObject];
  
  NSString *offerType = offer[kMEWConnectSocketType];
  NSString *offerSDP = offer[kMEWConnectSocketSDP];
  if (offerType && offerSDP) {
    RTCSdpType type = [RTCSessionDescription typeForString:offerType];
    RTCSessionDescription *description = [[RTCSessionDescription alloc] initWithType:type sdp:offerSDP];
    dispatch_async(dispatch_get_main_queue(), ^{
      [self.rtcService connectWithOffer:description];
    });
  }
}

- (void) _signalAnswer:(NSArray *)data {
//  NSString *dataString = [data firstObject][@"data"];
//  NSDictionary *dataObj = [[NSJSONSerialization JSONObjectWithData:[dataString dataUsingEncoding:NSUTF8StringEncoding]
//                                                           options:0
//                                                             error:nil] firstObject];
//  [self _answerReceived:dataObj];
}

- (void) _signalError:(NSArray *)data {
  dispatch_async(dispatch_get_main_queue(), ^{
    [self disconnect];
    if ([self.delegate respondsToSelector:@selector(MEWConnectDidReceiveError:)]) {
      [self.delegate MEWConnectDidReceiveError:self];
    }
  });
  DDLogVerbose(@"MEWConnect: error (%@)", data);
}

- (void) _signalAny:(SocketAnyEvent *)event {
  DDLogVerbose(@"MEWConnect: any (%@)", event);
}

#pragma mark - WebRTC Communication

- (void) _sendAnswer:(RTCSessionDescription *)answer {
  NSString *answerType = [RTCSessionDescription stringForType:answer.type];
  NSString *answerSDP = answer.sdp;
  NSArray *answerMessage = @[@{kMEWConnectSocketSDP: answerSDP,
                               kMEWConnectSocketType: answerType}];
  NSData *answerJsonData = [NSJSONSerialization dataWithJSONObject:answerMessage
                                                           options:0
                                                             error:nil];
  NSString *answerJsonString = [[NSString alloc] initWithData:answerJsonData encoding:NSUTF8StringEncoding];
  NSDictionary *message = @{kMEWConnectMessageData: answerJsonString,
                            kMEWConnectMessageConnId: self.connectionId};
  [self _emit:kMEWConnectEmitAnswerSignal message:message];
}

- (void) _sendTryTurn {
  NSDictionary *message = @{kMEWConnectMessageCont: @YES,
                            kMEWConnectMessageConnId: self.connectionId};
  [self _emit:kMEWConnectEmitTryTurn message:message];
}

- (void) _sendConnected {
  [self _emit:kMEWConnectEmitRTCConnected message:self.connectionId];
}

#pragma mark - MEWRTCServiceDelegate

- (void) MEWRTCService:(id<MEWRTCService>)rtcService didGenerateAnswer:(RTCSessionDescription *)answer {
  [self _sendAnswer:answer];
}

- (void) MEWRTCServiceConnectionDidFailed:(id<MEWRTCService>)rtcService {
  [self _sendTryTurn];
}

- (void) MEWRTCServiceConnectionDidConnected:(id<MEWRTCService>)rtcService {
  [self _sendConnected];
}

- (void) MEWRTCServiceDataChannelDidOpen:(id<MEWRTCService>)rtcService {
  if ([self.delegate respondsToSelector:@selector(MEWConnectDidConnected:)]) {
    dispatch_async(dispatch_get_main_queue(), ^{
      self.connectionStatus = MEWConnectStatusConnected;
      [self _cancelTimeoutTimer];
      [self.delegate MEWConnectDidConnected:self];
    });
  }
}

- (void) MEWRTCService:(id<MEWRTCService>)rtcService didReceiveMessage:(NSDictionary *)message {
  DDLogVerbose(@"MESSAGE: %@", message);
  
  NSDictionary *context = @{kMappingContextModelClassKey: NSStringFromClass([MEWConnectCommand class])};
  NSError *error = nil;
  MEWConnectCommand *command = [self.messageMapper mapServerResponse:message
                                                  withMappingContext:context
                                                               error:&error];
  if (error) {
    DDLogVerbose(@"%@", error);
  } else {
    @weakify(self);
    dispatch_async(dispatch_get_main_queue(), ^{
      @strongify(self);
      if ([self.delegate respondsToSelector:@selector(MEWConnect:didReceiveMessage:)]) {
        [self.delegate MEWConnect:self didReceiveMessage:command];
      }
    });
  }
}

@end
