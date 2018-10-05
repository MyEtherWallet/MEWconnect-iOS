//
//  MEWconnectServiceStateMachine.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 02/10/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "MEWconnectServiceStateMachine.h"

@interface MEWconnectServiceStateMachine ()
@property (nonatomic) NSDictionary *transitions;
@end

@implementation MEWconnectServiceStateMachine

- (instancetype) init {
  self = [super init];
  if (self) {
    self.transitions = @{// 0 -> 3
                         // 0 -> 0
                         @(MEWconnectServiceConnectionStateDisconnected)
                         : @[@(MEWconnectServiceConnectionStateSocketConnecting),
                             @(MEWconnectServiceConnectionStateDisconnected)],
                         
                         // 3 -> 4
                         // 3 -> 0
                         // 3 -> 2
                         @(MEWconnectServiceConnectionStateSocketConnecting)
                         : @[@(MEWconnectServiceConnectionStateSocketConnected),
                             @(MEWconnectServiceConnectionStateDisconnected),
                             @(MEWconnectServiceConnectionStateFailed)],
                         
                         // 4 -> 6
                         // 4 -> 0
                         // 4 -> 2
                         @(MEWconnectServiceConnectionStateSocketConnected)
                         : @[@(MEWconnectServiceConnectionStateMEWConnecting),
                             @(MEWconnectServiceConnectionStateDisconnected),
                             @(MEWconnectServiceConnectionStateFailed)],
                         
                         // 6 -> 7
                         // 6 -> 0
                         // 6 -> 2
                         @(MEWconnectServiceConnectionStateMEWConnecting)
                         : @[@(MEWconnectServiceConnectionStateMEWHandshake),
                             @(MEWconnectServiceConnectionStateDisconnected),
                             @(MEWconnectServiceConnectionStateFailed)],
                         
                         // 7 -> 8
                         // 7 -> 0
                         // 7 -> 2
                         @(MEWconnectServiceConnectionStateMEWHandshake)
                         : @[@(MEWconnectServiceConnectionStateMEWRTCConnecting),
                             @(MEWconnectServiceConnectionStateDisconnected),
                             @(MEWconnectServiceConnectionStateFailed)],
                         
                         // 8 -> 9
                         // 8 -> 0
                         // 8 -> 2
                         @(MEWconnectServiceConnectionStateMEWRTCConnecting)
                         : @[@(MEWconnectServiceConnectionStateMEWRTCRemoteUpdated),
                             @(MEWconnectServiceConnectionStateDisconnected),
                             @(MEWconnectServiceConnectionStateFailed)],
                         
                         // 9 -> 10
                         // 9 -> 0
                         // 9 -> 2
                         @(MEWconnectServiceConnectionStateMEWRTCRemoteUpdated)
                         : @[@(MEWconnectServiceConnectionStateMEWRTCAnswerPreparing),
                             @(MEWconnectServiceConnectionStateDisconnected),
                             @(MEWconnectServiceConnectionStateFailed)],
                         
                         // 10 -> 11
                         // 10 -> 0
                         // 10 -> 2
                         @(MEWconnectServiceConnectionStateMEWRTCAnswerPreparing)
                         : @[@(MEWconnectServiceConnectionStateMEWRTCLocalUpdated),
                             @(MEWconnectServiceConnectionStateDisconnected),
                             @(MEWconnectServiceConnectionStateFailed)],
                         
                         // 11 -> 12
                         // 11 -> 0
                         // 11 -> 2
                         @(MEWconnectServiceConnectionStateMEWRTCLocalUpdated)
                         : @[@(MEWconnectServiceConnectionStateMEWRTCAnswerPrepared),
                             @(MEWconnectServiceConnectionStateDisconnected),
                             @(MEWconnectServiceConnectionStateFailed)],
                         
                         // 12 -> 13
                         // 12 -> 0
                         // 12 -> 2
                         @(MEWconnectServiceConnectionStateMEWRTCAnswerPrepared)
                         : @[@(MEWconnectServiceConnectionStateMEWRTCConnected),
                             @(MEWconnectServiceConnectionStateDisconnected),
                             @(MEWconnectServiceConnectionStateFailed)],
                         
                         // 13 -> 14
                         // 13 -> 0
                         // 13 -> 2
                         @(MEWconnectServiceConnectionStateMEWRTCConnected)
                         : @[@(MEWconnectServiceConnectionStateDataChannelConnecting),
                             @(MEWconnectServiceConnectionStateDisconnected),
                             @(MEWconnectServiceConnectionStateFailed)],
                         
                         // 14 -> 15
                         // 14 -> 0
                         // 14 -> 2
                         @(MEWconnectServiceConnectionStateDataChannelConnecting)
                         : @[@(MEWconnectServiceConnectionStateDataChannelOpened),
                             @(MEWconnectServiceConnectionStateDisconnected),
                             @(MEWconnectServiceConnectionStateFailed)],
                         
                         // 15 -> 5
                         // 15 -> 0
                         // 15 -> 2
                         @(MEWconnectServiceConnectionStateDataChannelOpened)
                         : @[@(MEWconnectServiceConnectionStateSocketClosed),
                             @(MEWconnectServiceConnectionStateDisconnected),
                             @(MEWconnectServiceConnectionStateFailed)],
                         
                         // 5 -> 1
                         // 5 -> 0
                         // 5 -> 2
                         @(MEWconnectServiceConnectionStateSocketClosed)
                         : @[@(MEWconnectServiceConnectionStateConnected),
                             @(MEWconnectServiceConnectionStateDisconnected),
                             @(MEWconnectServiceConnectionStateFailed)],
                         
                         // 2 -> 6
                         // 2 -> 0
                         @(MEWconnectServiceConnectionStateFailed)
                         : @[@(MEWconnectServiceConnectionStateMEWConnecting),
                             @(MEWconnectServiceConnectionStateDisconnected)],
                         
                         // 1 -> 0
                         @(MEWconnectServiceConnectionStateConnected)
                         : @[@(MEWconnectServiceConnectionStateDisconnected)]
                         };
  }
  return self;
}

- (void) reset {
  _connectionType = MEWconnectServiceConnectionTypeStun;
  _connectionState = MEWconnectServiceConnectionStateDisconnected;
}

- (BOOL) applyTryTurn {
  if (_connectionType == MEWconnectServiceConnectionTypeStun) {
    NSLog(@"[OK]: TRY TURN: APPLY FROM: %d TO: %d", _connectionState, MEWconnectServiceConnectionStateMEWHandshake);
    _connectionType = MEWconnectServiceConnectionTypeTurn;
    _connectionState = MEWconnectServiceConnectionStateMEWHandshake;
    return YES;
  }
  NSLog(@"[ERROR]: TRY TURN: APPLY FROM: %d TO: %d", _connectionState, MEWconnectServiceConnectionStateMEWHandshake);
  return NO;
}

- (BOOL)applySocketConnecting {
  return [self _applyTransitionTo:MEWconnectServiceConnectionStateSocketConnecting];
}

- (BOOL) applySocketConnected {
  return [self _applyTransitionTo:MEWconnectServiceConnectionStateSocketConnected];
}

- (BOOL) applyMEWConnecting {
  return [self _applyTransitionTo:MEWconnectServiceConnectionStateMEWConnecting];
}

- (BOOL) applyMEWHandshake {
  return [self _applyTransitionTo:MEWconnectServiceConnectionStateMEWHandshake];
}

- (BOOL) applyMEWRTCOfferReceived {
  return [self _applyTransitionTo:MEWconnectServiceConnectionStateMEWRTCConnecting];
}

- (BOOL) applyMEWRTCRemoteUpdated {
  return [self _applyTransitionTo:MEWconnectServiceConnectionStateMEWRTCRemoteUpdated];
}

- (BOOL) applyMEWRTCAnswerPreparing {
  return [self _applyTransitionTo:MEWconnectServiceConnectionStateMEWRTCAnswerPreparing];
}

- (BOOL) applyMEWRTCLocalUpdated {
  return [self _applyTransitionTo:MEWconnectServiceConnectionStateMEWRTCLocalUpdated];
}

- (BOOL) applyMEWRTCAnswerPrepared {
  return [self _applyTransitionTo:MEWconnectServiceConnectionStateMEWRTCAnswerPrepared];
}

- (BOOL) applyMEWRTCConnected {
  return [self _applyTransitionTo:MEWconnectServiceConnectionStateMEWRTCConnected];
}

- (BOOL) applyMEWRTCDataChannelConnecting {
  return [self _applyTransitionTo:MEWconnectServiceConnectionStateDataChannelConnecting];
}

- (BOOL) applyMEWRTCDataChannelOpened {
  return [self _applyTransitionTo:MEWconnectServiceConnectionStateDataChannelOpened];
}

- (BOOL) applySocketClosed {
  return [self _applyTransitionTo:MEWconnectServiceConnectionStateSocketClosed];
}

- (BOOL) applyConnected {
  return [self _applyTransitionTo:MEWconnectServiceConnectionStateConnected];
}

- (BOOL) applyFailed {
  return [self _applyTransitionTo:MEWconnectServiceConnectionStateFailed];
}

#pragma mark - Public

- (BOOL) final {
  return _connectionState == MEWconnectServiceConnectionStateConnected;
}

#pragma mark - Private

- (BOOL) _applyTransitionTo:(MEWconnectServiceConnectionState)state {
  NSArray *nextPossibleStates = self.transitions[@(_connectionState)];
  if ([nextPossibleStates containsObject:@(state)]) {
    NSLog(@"[OK]: APPLY FROM: %d TO: %d", _connectionState, state);
    _connectionState = state;
    return YES;
  }
  NSLog(@"[ERROR]: APPLY FROM: %d TO: %d", _connectionState, state);
  return NO;
}

@end
