//
//  MEWRTCServiceImplementation.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 24/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import WebRTC;
@import libextobjc.EXTScope;
@import CocoaLumberjack;

static const int ddLogLevel = DDLogLevelVerbose;

#import "MEWRTCConstants.h"

#import "MEWRTCServiceImplementation.h"

@interface MEWRTCServiceImplementation () <RTCPeerConnectionDelegate, RTCDataChannelDelegate>
@property (nonatomic, strong) RTCPeerConnectionFactory *peerConnectionFactory;
@property (nonatomic, strong) RTCPeerConnection *peerConnection;
@property (nonatomic, strong) RTCDataChannel *dataChannel;
@end

@implementation MEWRTCServiceImplementation
@synthesize delegate = _delegate;

- (void)connectWithOffer:(RTCSessionDescription *)offer {
  self.peerConnection = [self.peerConnectionFactory peerConnectionWithConfiguration:[self _RTCConfigurationWithIceServers:nil]
                                                                        constraints:[self _RTCMediaConstraints]
                                                                           delegate:self];
  @weakify(self);
  [self.peerConnection setRemoteDescription:offer completionHandler:^(NSError * _Nullable error) {
    @strongify(self);
    if (error) {
      DDLogVerbose(@"MEWRTC Remote description error: %@", error);
    } else {
      [self _prepareAnswer];
    }
  }];
}

- (void) disconnect {
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

#pragma mark - Private communicating

- (void) _prepareAnswer {
  @weakify(self);
  [self.peerConnection answerForConstraints:[self _RTCMediaConstraints]
                          completionHandler:^(RTCSessionDescription * _Nullable sdp, NSError * _Nullable error) {
                            @strongify(self);
                            if (error) {
                              DDLogVerbose(@"MEWRTC Answer error: %@", error);
                            } else if (!sdp) {
                              DDLogVerbose(@"MEWRTC Answer undefined behaviour");
                            } else {
                              [self _updateLocalDescription:sdp];
                            }
                          }];
}

- (void) _updateLocalDescription:(RTCSessionDescription *)localDescription {
  [self.peerConnection setLocalDescription:localDescription
                         completionHandler:^(NSError * _Nullable error) {
                           if (error) {
                             DDLogVerbose(@"MEWRTC Local description error: %@", error);
                           }
                         }];
}

/* peerConnection:didGenerateIceCandidate */
- (void) _generatingIceServersDelayed {
  [self.delegate MEWRTCService:self didGenerateAnswer:self.peerConnection.localDescription];
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
  self.dataChannel.delegate = self;
  self.dataChannel = nil;
  [NSObject cancelPreviousPerformRequestsWithTarget:self];
}
                         
#pragma mark - RTCPeerConnectionDelegate

/** Called when the SignalingState changed. */
- (void)peerConnection:(RTCPeerConnection *)peerConnection didChangeSignalingState:(RTCSignalingState)stateChanged {
}

/** Called when media is received on a new stream from remote peer. */
- (void)peerConnection:(RTCPeerConnection *)peerConnection didAddStream:(RTCMediaStream *)stream {
}

/** Called when a remote peer closes a stream. */
- (void)peerConnection:(RTCPeerConnection *)peerConnection didRemoveStream:(RTCMediaStream *)stream {
}

/** Called when negotiation is needed, for example ICE has restarted. */
- (void)peerConnectionShouldNegotiate:(RTCPeerConnection *)peerConnection {
}

/** Called any time the IceConnectionState changes. */
- (void)peerConnection:(RTCPeerConnection *)peerConnection didChangeIceConnectionState:(RTCIceConnectionState)newState {
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
      [self _clearConnection];
      break;
    }
    case RTCIceConnectionStateCompleted: {
      DDLogVerbose(@"RTC Ice connection state: COMPLETED");
      break;
    }
    case RTCIceConnectionStateConnected: {
        self.dataChannel = [self.peerConnection dataChannelForLabel:MEWRTCDataChannelLabel configuration:[self _RTCDataChannelConfiguration]];
        self.dataChannel.delegate = self;
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
      [self _clearConnection];
      break;
    }
    case RTCIceConnectionStateFailed: {
      DDLogVerbose(@"RTC Ice connection state: FAILED");
      dispatch_async(dispatch_get_main_queue(), ^{
        [self.delegate MEWRTCServiceConnectionDidFailed:self];
      });
      break;
    }
    default:
      break;
  }
}

/** Called any time the IceGatheringState changes. */
- (void)peerConnection:(RTCPeerConnection *)peerConnection didChangeIceGatheringState:(RTCIceGatheringState)newState {
}

/** New ice candidate has been found. */
- (void)peerConnection:(RTCPeerConnection *)peerConnection didGenerateIceCandidate:(RTCIceCandidate *)candidate {
  /* Waiting all ice candidates */
  dispatch_async(dispatch_get_main_queue(), ^{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(_generatingIceServersDelayed) withObject:nil afterDelay:0.2];
  });
}

/** Called when a group of local Ice candidates have been removed. */
- (void)peerConnection:(RTCPeerConnection *)peerConnection didRemoveIceCandidates:(NSArray<RTCIceCandidate *> *)candidates {
}

/** New data channel has been opened. */
- (void)peerConnection:(RTCPeerConnection *)peerConnection didOpenDataChannel:(RTCDataChannel *)dataChannel {
}

#pragma mark - RTCDataChannelDelegate

/** The data channel state changed. */
- (void)dataChannelDidChangeState:(RTCDataChannel *)dataChannel {
  switch (dataChannel.readyState) {
    case RTCDataChannelStateConnecting: {
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
- (void)dataChannel:(RTCDataChannel *)dataChannel didReceiveMessageWithBuffer:(RTCDataBuffer *)buffer {
  NSDictionary *message = [NSJSONSerialization JSONObjectWithData:buffer.data options:0 error:nil];
  dispatch_async(dispatch_get_main_queue(), ^{
    [self.delegate MEWRTCService:self didReceiveMessage:message];
  });
}

@end
