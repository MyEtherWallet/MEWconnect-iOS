//
//  MEWConnectServiceImplementation.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 24/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

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

#import "MEWcrypto.h"
#import "MEWcryptoMessage.h"

#import "MEWConnectServiceImplementation.h"

#import "MEWConnectCommand.h"

#define DEBUG_ANYSIGNAL 0
#if !DEBUG
  #ifdef DEBUG_ANYSIGNAL
    #undef DEBUG_ANYSIGNAL
  #endif
  #define DEBUG_ANYSIGNAL 0
#endif

static NSString *const kMEWConnectCurrentSchemaVersion  =  @"0.0.1";

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
  if ([params count] < 3) {
    return NO;
  }
  //[params firstObject]; WebSchemaVersion
  self.privateKey = params[1]; //second
  self.connectionId = [params lastObject];
  if (!self.connectionId || !self.privateKey ||
      [self.connectionId length] == 0 || [self.privateKey length] == 0) {
    return NO;
  }
  if (!self.signallingServerURL) {
    return NO;
  }
  [self.MEWcrypto configurateWithConnectionPrivateKey:[self.privateKey parseHexData]];
  self.socketManager = [[SocketManager alloc] initWithSocketURL:self.signallingServerURL config:[self _socketConfig]];
  SocketIOClient *client = [self.socketManager defaultSocket];
  [self _defineSignalsWithSocketClient:client];
  [client connect];
  [self _createTimeoutTimer];
  self.connectionStatus = MEWConnectStatusConnecting;
  return YES;
}

- (void) disconnect {
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
  NSData *data = [NSJSONSerialization dataWithJSONObject:serializedMessage options:0 error:nil];
  MEWcryptoMessage *cryptoMessage = [self.MEWcrypto encryptMessage:data];
  return [self.rtcService sendMessage:[cryptoMessage representation]];
}

#pragma mark - NSURLSessionDelegate

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler {
  completionHandler(NSURLSessionAuthChallengeUseCredential, [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust]);
}

#pragma mark - Private

- (NSDictionary *) _socketConfig {
  NSData *toSignHashData = [self.MEWcrypto hashPersonalMessage:[self.privateKey dataUsingEncoding:NSUTF8StringEncoding]];
  NSData *privateKeyData = [self.privateKey parseHexData];
  NSData *signedData = [toSignHashData signWithPrivateKeyData:privateKeyData];
  NSString *signedMessage = [signedData hexadecimalString];

  NSDictionary *config = @{kMEWConnectSocketConfigLog             : @NO,
                           kMEWConnectSocketConfigCompress        : @YES,
                           kMEWConnectSocketConfigSecure          : @YES,
                           kMEWConnectSocketConfigSelfSigned      : @YES,
                           kMEWConnectSocketConfigSessionDelegate : self,
                           kMEWConnectSocketConfigConnectParams   : @{
                               kMEWConnectSocketConfigConnId      : self.connectionId,
                               kMEWConnectSocketConfigStage       : MEWConnectSocketReceiver,
                               kMEWConnectMessageSigned: signedMessage}
                           };
  DDLogVerbose(@"MEWconnect. Config: %@", config);
  return config;
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
  
  /* Confirmation failed signal */
  [client on:kMEWConnectSignalConfirmationFailed callback:^(NSArray * data, SocketAckEmitter * emit) {
    @strongify(self);
    [self _signalConfirmationError:data];
  }];
  
  /* Any signal */
#if DEBUG_ANYSIGNAL
  [client onAny:^(SocketAnyEvent * _Nonnull event) {
    @strongify(self);
    [self _signalAny:event];
  }];
#endif /* DEBUG_ANYSYGNAL */
}

- (void) _emit:(NSString *)emit message:(id)message {
  DDLogVerbose(@"MEWConnect: emit message: %@ (%@)", emit, message);
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
    NSData *toSignHashData = [self.MEWcrypto hashPersonalMessage:[self.privateKey dataUsingEncoding:NSUTF8StringEncoding]];
    NSData *privateKeyData = [self.privateKey parseHexData];
    NSData *signedData = [toSignHashData signWithPrivateKeyData:privateKeyData];
    NSString *signedMessage = [signedData hexadecimalString];

    if (signedMessage) {
      NSData *currentSchemaVersionData = [kMEWConnectCurrentSchemaVersion dataUsingEncoding:NSUTF8StringEncoding];
      MEWcryptoMessage *cryptoMessage = [self.MEWcrypto encryptMessage:currentSchemaVersionData];
      NSDictionary *message = @{kMEWConnectMessageSigned: signedMessage,
                                kMEWConnectMessageConnId: self.connectionId,
                                kMEWConnectMessageVersion: [cryptoMessage representation] ?: @""};
      [self _emit:kMEWConnectEmitSignature message:message];
    }
  } else {
    NSDictionary *message = @{kMEWConnectMessageConnId: self.connectionId,
                              kMEWConnectMessageVersion: kMEWConnectCurrentSchemaVersion};
    [self _emit:kMEWConnectEmitSignature message:message];
  }
}

- (void) _signalOffer:(NSArray *)data {
  DDLogVerbose(@"MEWConnect: offer");
  NSDictionary *messageRepresentation = [data firstObject][@"data"];
  MEWcryptoMessage *message = [MEWcryptoMessage messageWithRepresentation:messageRepresentation];
  NSData *decryptedMessage = [self.MEWcrypto decryptMessage:message];
  if (decryptedMessage) {
    NSError *error = nil;
    NSDictionary *offer = [NSJSONSerialization JSONObjectWithData:decryptedMessage
                                                           options:0
                                                             error:&error];
#if DEBUG
    DDLogError(@"JSON Parse error: %@", [error localizedDescription]);
#endif
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
}

- (void) _signalAnswer:(NSArray *)data {
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

- (void) _signalConfirmationError:(NSArray *)data {
  dispatch_async(dispatch_get_main_queue(), ^{
    [self disconnect];
    if ([self.delegate respondsToSelector:@selector(MEWConnectDidReceiveError:)]) {
      [self.delegate MEWConnectDidReceiveError:self];
    }
  });
  DDLogVerbose(@"MEWConnect: confirmation failed (%@)", data);
}

#if DEBUG_ANYSIGNAL
- (void) _signalAny:(SocketAnyEvent *)event {
  DDLogVerbose(@"MEWConnect: any (%@)", event);
}
#endif /* DEBUG_ANYSYGNAL */

#pragma mark - WebRTC Communication

- (void) _sendAnswer:(RTCSessionDescription *)answer {
  NSString *answerType = [RTCSessionDescription stringForType:answer.type];
  NSString *answerSDP = answer.sdp;
  NSArray *answerMessage = @[@{kMEWConnectSocketSDP: answerSDP,
                               kMEWConnectSocketType: answerType}];
  NSData *answerJsonData = [NSJSONSerialization dataWithJSONObject:answerMessage
                                                           options:0
                                                             error:nil];
  MEWcryptoMessage *cryptoMessage = [self.MEWcrypto encryptMessage:answerJsonData];
  NSDictionary *message = @{kMEWConnectMessageData: [cryptoMessage representation],
                            kMEWConnectMessageConnId: self.connectionId};
  [self _emit:kMEWConnectEmitAnswerSignal message:message];
}

- (void) _sendTryTurn {
  //TODO: ?
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
  MEWcryptoMessage *cryptoMessage = [MEWcryptoMessage messageWithRepresentation:message];
  NSData *decryptedMessage = [self.MEWcrypto decryptMessage:cryptoMessage];
  if (!decryptedMessage) {
    return;
  }
  @try {
    message = [NSJSONSerialization JSONObjectWithData:decryptedMessage
                                              options:0
                                                error:nil];
  }
  @catch (NSException *exception) {
    DDLogError(@"MEWRTC. Received message, but can't parse: %@", [exception reason]);
    return;
  }
#if DEBUG_ANYSIGNAL
  DDLogVerbose(@"MESSAGE: %@", message);
#endif
  
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
