//
//  MEWRTCServiceImplementation.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 24/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import WebRTC;
@import libextobjc.EXTScope;

#import "MEWRTCConstants.h"

#import "MEWRTCServiceImplementation.h"

static NSTimeInterval MEWRTCServiceImplementationIceGatheringStateCompleteTimeout  = 1.0;

@interface MEWRTCServiceImplementation () <RTCPeerConnectionDelegate, RTCDataChannelDelegate>
@property (nonatomic, strong) RTCPeerConnectionFactory *peerConnectionFactory;
@property (nonatomic, strong) RTCPeerConnection *peerConnection;
@property (nonatomic, strong) RTCDataChannel *dataChannel;
@end

@implementation MEWRTCServiceImplementation {
  NSTimer *_gatheringTimeout;
}
@synthesize delegate = _delegate;

- (void) connectWithType:(NSString *)type andSdp:(NSString *)sdp {
  [self disconnect];
  
  RTCSdpType sdpType = [RTCSessionDescription typeForString:type];
  RTCSessionDescription *description = [[RTCSessionDescription alloc] initWithType:sdpType sdp:sdp];
  
  self.peerConnection = [self.peerConnectionFactory peerConnectionWithConfiguration:[self _RTCConfigurationWithIceServers:nil]
                                                                        constraints:[self _RTCMediaConstraints]
                                                                           delegate:self];
  @weakify(self);
  [self.peerConnection setRemoteDescription:description completionHandler:^(NSError * _Nullable error) {
    @strongify(self);
    if (error) {
      DDLogVerbose(@"MEWRTC Remote description error: %@", error);
    } else {
      [self.delegate MEWRTCServiceDidUpdateRemoteDescription:self];
    }
  }];
}

- (void) prepareAnswer {
  @weakify(self);
  [self.peerConnection answerForConstraints:[self _RTCMediaConstraints]
                          completionHandler:^(RTCSessionDescription * _Nullable sdp, NSError * _Nullable error) {
                            @strongify(self);
                            if (error) {
                              DDLogVerbose(@"MEWRTC Answer error: %@", error);
                              dispatch_async(dispatch_get_main_queue(), ^{
                                [self disconnect];
                                [self.delegate MEWRTCServiceConnectionDidFailed:self];
                              });
                            } else if (!sdp) {
                              DDLogVerbose(@"MEWRTC Answer undefined behaviour");
                              dispatch_async(dispatch_get_main_queue(), ^{
                                [self disconnect];
                                [self.delegate MEWRTCServiceConnectionDidFailed:self];
                              });
                            } else {
                              [self.delegate MEWRTCService:self didPrepareAnswer:sdp];
                            }
                          }];
}

- (void) updateLocalDescriptionWithAnswer:(RTCSessionDescription *)answer {
  @weakify(self);
  [self.peerConnection setLocalDescription:answer
                         completionHandler:^(NSError * _Nullable error) {
                           if (error) {
                             @strongify(self);
                             DDLogVerbose(@"MEWRTC Local description error: %@", error);
                             dispatch_async(dispatch_get_main_queue(), ^{
                               [self disconnect];
                               [self.delegate MEWRTCServiceConnectionDidFailed:self];
                             });
                           }
                         }];
}

- (void) openDataChannel {
  self.dataChannel = [self.peerConnection dataChannelForLabel:MEWRTCDataChannelLabel configuration:[self _RTCDataChannelConfiguration]];
  self.dataChannel.delegate = self;
  [self dataChannelDidChangeState:self.dataChannel];
}

- (void) disconnect {
  [_gatheringTimeout invalidate];
  _gatheringTimeout = nil;
  [self.dataChannel close];
  [self.peerConnection close];
  [self _clearConnection];
}

- (BOOL) sendMessage:(id)message {
  if (self.dataChannel.readyState == RTCDataChannelStateOpen) {
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:message options:0 error:&error];
    if (!error) {
      RTCDataBuffer *buffer = [[RTCDataBuffer alloc] initWithData:data isBinary:NO];
      [self.dataChannel sendData:buffer];
      return YES;
    }
  }
  return NO;
}

#pragma mark - Private

- (RTCConfiguration *) _RTCConfigurationWithIceServers:(NSArray *)iceServers {
  if ([iceServers count] == 0) {
    RTCIceServer *server = [[RTCIceServer alloc] initWithURLStrings:@[MEWRTCDefaultSTUNIceServerURL]];
    iceServers = @[server];
  }
  RTCConfiguration *configuration = [[RTCConfiguration alloc] init];
  configuration.iceServers = iceServers;
  return configuration;
}

- (RTCMediaConstraints *) _RTCMediaConstraints {
  return [[RTCMediaConstraints alloc] initWithMandatoryConstraints:nil
                                               optionalConstraints:nil];
}

- (RTCDataChannelConfiguration *) _RTCDataChannelConfiguration {
  RTCDataChannelConfiguration *dataChannelConfiguration = [[RTCDataChannelConfiguration alloc] init];
  dataChannelConfiguration.channelId = MEWRTCDataChannelId;
  return dataChannelConfiguration;
}

- (void) _clearConnection {
  self.peerConnection = nil;
  self.dataChannel.delegate = nil;
  self.dataChannel = nil;
}

- (void) _generateAnswer:(BOOL)forceWhileGathering {
  if (self.peerConnection &&
      self.peerConnection.iceConnectionState != RTCIceConnectionStateFailed &&
      self.peerConnection.iceConnectionState != RTCIceConnectionStateConnected &&
      (forceWhileGathering || self.peerConnection.iceGatheringState == RTCIceGatheringStateComplete)) {
        dispatch_async(dispatch_get_main_queue(), ^{
          RTCSessionDescription *localDescription = self.peerConnection.localDescription;
          NSString *answerType = [RTCSessionDescription stringForType:localDescription.type];
          NSString *answerSDP = localDescription.sdp;
          if (answerSDP && answerType) {
            [self.delegate MEWRTCService:self didGenerateAnswerWithType:answerType sdp:answerSDP];
          }
        });
  }
}
                         
#pragma mark - RTCPeerConnectionDelegate

/** Called when the SignalingState changed. */
- (void)peerConnection:(__unused RTCPeerConnection *)peerConnection didChangeSignalingState:(RTCSignalingState)stateChanged {
  switch (stateChanged) {
    case RTCSignalingStateHaveRemoteOffer: {
      DDLogVerbose(@"RTC Signaling state: REMOTE OFFER");
      break;
    }
    case RTCSignalingStateHaveRemotePrAnswer: {
      DDLogVerbose(@"RTC Signaling state: REMOTE PR ANSWER");
      break;
    }
    case RTCSignalingStateHaveLocalPrAnswer: {
      DDLogVerbose(@"RTC Signaling state: LOCAL PR ANSWER");
      break;
    }
    case RTCSignalingStateHaveLocalOffer: {
      DDLogVerbose(@"RTC Signaling state: LOCAL OFFER");
      break;
    }
    case RTCSignalingStateStable: {
      DDLogVerbose(@"RTC Signaling state: STABLE");
      break;
    }
    case RTCSignalingStateClosed: {
      DDLogVerbose(@"RTC Signaling state: CLOSED");
      break;
    }
      
    default:
      break;
  }
}

/** Called when media is received on a new stream from remote peer. */
- (void)peerConnection:(__unused RTCPeerConnection *)peerConnection didAddStream:(__unused RTCMediaStream *)stream {
}

/** Called when a remote peer closes a stream. */
- (void)peerConnection:(__unused RTCPeerConnection *)peerConnection didRemoveStream:(__unused RTCMediaStream *)stream {
}

/** Called when negotiation is needed, for example ICE has restarted. */
- (void)peerConnectionShouldNegotiate:(__unused RTCPeerConnection *)peerConnection {
}

/** Called any time the IceConnectionState changes. */
- (void)peerConnection:(__unused RTCPeerConnection *)peerConnection didChangeIceConnectionState:(RTCIceConnectionState)newState {
  switch (newState) {
    case RTCIceConnectionStateNew: {
      DDLogVerbose(@"RTC Ice connection state: NEW");
      break;
    }
    case RTCIceConnectionStateChecking: {
      DDLogVerbose(@"RTC Ice connection state: CHECKING");
      break;
    }
    case RTCIceConnectionStateClosed: {
      DDLogVerbose(@"RTC Ice connection state: CLOSED");
      dispatch_async(dispatch_get_main_queue(), ^{
        [self disconnect];
      });
      break;
    }
    case RTCIceConnectionStateCompleted: {
      DDLogVerbose(@"RTC Ice connection state: COMPLETED");
      break;
    }
    case RTCIceConnectionStateConnected: {
      DDLogVerbose(@"RTC Ice connection state: CONNECTED");
      dispatch_async(dispatch_get_main_queue(), ^{
        [self.delegate MEWRTCServiceConnectionDidConnected:self];
      });
      break;
    }
    case RTCIceConnectionStateCount: {
      DDLogVerbose(@"RTC Ice connection state: COUNT");
      break;
    }
    case RTCIceConnectionStateDisconnected: {
      DDLogVerbose(@"RTC Ice connection state: DISCONNECTED");
      dispatch_async(dispatch_get_main_queue(), ^{
        [self disconnect];
        [self.delegate MEWRTCServiceConnectionDidDisconnected:self];
      });
      break;
    }
    case RTCIceConnectionStateFailed: {
      DDLogVerbose(@"RTC Ice connection state: FAILED");
      dispatch_async(dispatch_get_main_queue(), ^{
        [self disconnect];
        [self.delegate MEWRTCServiceConnectionDidFailed:self];
      });
      break;
    }
    default:
      break;
  }
}

/** Called any time the IceGatheringState changes. */
- (void)peerConnection:(__unused RTCPeerConnection *)peerConnection didChangeIceGatheringState:(RTCIceGatheringState)newState {
  switch (newState) {
    case RTCIceGatheringStateNew: {
      DDLogVerbose(@"RTC Ice gathering state: NEW");
      break;
    }
    case RTCIceGatheringStateGathering: {
      DDLogVerbose(@"RTC Ice gathering state: GATHERING");
      @weakify(self);
      _gatheringTimeout = [NSTimer timerWithTimeInterval:MEWRTCServiceImplementationIceGatheringStateCompleteTimeout
                                                 repeats:NO
                                                   block:^(__unused NSTimer * _Nonnull timer) {
                                                     @strongify(self);
                                                     [self _generateAnswer:YES];
                                                   }];
      [[NSRunLoop mainRunLoop] addTimer:_gatheringTimeout forMode:NSRunLoopCommonModes];
      break;
    }
    case RTCIceGatheringStateComplete: {
      [_gatheringTimeout invalidate];
      _gatheringTimeout = nil;
      DDLogVerbose(@"RTC Ice gathering state: COMPLETE");
      [self _generateAnswer:NO];
      break;
    }
      
    default:
      break;
  }
}

/** New ice candidate has been found. */
- (void)peerConnection:(__unused RTCPeerConnection *)peerConnection didGenerateIceCandidate:(__unused RTCIceCandidate *)candidate {
}

/** Called when a group of local Ice candidates have been removed. */
- (void)peerConnection:(__unused RTCPeerConnection *)peerConnection didRemoveIceCandidates:(__unused NSArray<RTCIceCandidate *> *)candidates {
}

/** New data channel has been opened. */
- (void)peerConnection:(__unused RTCPeerConnection *)peerConnection didOpenDataChannel:(__unused RTCDataChannel *)dataChannel {
}

#pragma mark - RTCDataChannelDelegate

/** The data channel state changed. */
- (void)dataChannelDidChangeState:(__unused RTCDataChannel *)dataChannel {
  switch (dataChannel.readyState) {
    case RTCDataChannelStateConnecting: {
      [self.delegate MEWRTCServiceDataChannelConnecting:self];
      DDLogVerbose(@"RTC Data Channel connecting");
      break;
    }
    case RTCDataChannelStateOpen: {
      DDLogVerbose(@"RTC Data Channel open");
      [self.delegate MEWRTCServiceDataChannelDidOpen:self];
      break;
    }
    case RTCDataChannelStateClosing: {
      DDLogVerbose(@"RTC Data Channel closing");
      break;
    }
    case RTCDataChannelStateClosed: {
      DDLogVerbose(@"RTC Data Channel closed");
      break;
    }
    default:
      break;
  }
}

/** The data channel successfully received a data buffer. */
- (void)dataChannel:(__unused RTCDataChannel *)dataChannel didReceiveMessageWithBuffer:(RTCDataBuffer *)buffer {
  NSDictionary *message = [NSJSONSerialization JSONObjectWithData:buffer.data options:0 error:nil];
  dispatch_async(dispatch_get_main_queue(), ^{
    [self.delegate MEWRTCService:self didReceiveMessage:message];
  });
}

@end
