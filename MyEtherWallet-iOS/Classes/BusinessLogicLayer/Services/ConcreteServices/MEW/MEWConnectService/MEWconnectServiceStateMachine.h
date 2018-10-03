//
//  MEWconnectServiceStateMachine.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 02/10/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

#import "MEWconnectServiceStateMachineTypes.h"

NS_ASSUME_NONNULL_BEGIN

@interface MEWconnectServiceStateMachine : NSObject {
  MEWconnectServiceConnectionType _connectionType;
  MEWconnectServiceConnectionState _connectionState;
}
@property (nonatomic, readonly) BOOL final;
@property (nonatomic, readonly) MEWconnectServiceConnectionType connectionType;

/**
 Reset state machine
 
 fromState: Any
 
 toState: MEWconnectServiceConnectionStateDisconnected
 
 fromType: Any
 
 toType: MEWconnectServiceConnectionTypeStun
 */
- (void) reset;

/**
 Socket connecting
 
 fromState: MEWconnectServiceConnectionStateDisconnected
 
 toState: MEWconnectServiceConnectionStateSocketConnecting
 */
- (BOOL) applySocketConnecting;

/**
 Socket connected
 
 fromState: MEWconnectServiceConnectionStateSocketConnecting
 
 toState: MEWconnectServiceConnectionStateSocketConnected
 */
- (BOOL) applySocketConnected;

/**
 MEWconnect initiated
 
 fromState: MEWconnectServiceConnectionStateSocketConnected
 
 toState: MEWconnectServiceConnectionStateMEWConnecting
 */
- (BOOL) applyMEWConnecting;

/**
 MEWconnect hanshake
 
 fromState: MEWconnectServiceConnectionStateMEWConnecting
 
 toState: MEWconnectServiceConnectionStateMEWHandshake
 */
- (BOOL) applyMEWHandshake;

/**
 WebRTC Offer received
 
 fromState: MEWconnectServiceConnectionStateMEWHandshake
 
 toState: MEWconnectServiceConnectionStateMEWRTCConnecting
 */
- (BOOL) applyMEWRTCOfferReceived;

/**
 WebRTC remote description updated
 
 fromState: MEWconnectServiceConnectionStateMEWRTCConnecting
 
 toState: MEWconnectServiceConnectionStateMEWRTCRemoteUpdated
 */
- (BOOL) applyMEWRTCRemoteUpdated;

/**
 WebRTC answer preparing
 
 fromState: MEWconnectServiceConnectionStateMEWRTCRemoteUpdated
 
 toState: MEWconnectServiceConnectionStateMEWRTCAnswerPreparing
 */
- (BOOL) applyMEWRTCAnswerPreparing;

/**
 WebRTC local description updated
 
 fromState: MEWconnectServiceConnectionStateMEWRTCAnswerPreparing
 
 toState: MEWconnectServiceConnectionStateMEWRTCLocalUpdated
 */
- (BOOL) applyMEWRTCLocalUpdated;

/**
 WebRTC answer prepared
 
 fromState: MEWconnectServiceConnectionStateMEWRTCLocalUpdated
 
 toState: MEWconnectServiceConnectionStateMEWRTCAnswerPrepared
 */
- (BOOL) applyMEWRTCAnswerPrepared;

/**
 WebRTC connected
 
 fromState: MEWconnectServiceConnectionStateMEWRTCAnswerPrepared
 
 toState: MEWconnectServiceConnectionStateMEWRTCConnected
 */
- (BOOL) applyMEWRTCConnected;

/**
 WebRTC data channel connecting
 
 fromState: MEWconnectServiceConnectionStateMEWRTCConnected
 
 toState: MEWconnectServiceConnectionStateDataChannelConnecting
 */
- (BOOL) applyMEWRTCDataChannelConnecting;

/**
 WebRTC data channel opened
 
 fromState: MEWconnectServiceConnectionStateDataChannelConnecting
 
 toState: MEWconnectServiceConnectionStateDataChannelOpened
 */
- (BOOL) applyMEWRTCDataChannelOpened;

/**
 Socket server closed
 
 fromState: MEWconnectServiceConnectionStateDataChannelOpened
 
 toState: MEWconnectServiceConnectionStateSocketClosed
 */
- (BOOL) applySocketClosed;

/**
 MEWconnect connected
 
 fromState: MEWconnectServiceConnectionStateSocketClosed
 
 toState: MEWconnectServiceConnectionStateConnected
 */
- (BOOL) applyConnected;

/**
 Switch to TURN connection
 
 fromState: MEWconnectServiceConnectionStateFailed
 
 toState: MEWconnectServiceConnectionStateMEWConnecting
 
 fromType: MEWconnectServiceConnectionTypeStun
 
 toType: MEWconnectServiceConnectionTypeTurn
 */
- (BOOL) applyTryTurn;

/**
 Connection failed
 
 fromState: Any
 
 toState: MEWconnectServiceConnectionStateFailed
 */
- (BOOL) applyFailed;
@end

NS_ASSUME_NONNULL_END
