//
//  MEWconnectServiceStateMachineTypes.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 02/10/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

typedef NS_ENUM(short, MEWconnectServiceConnectionType) {
  MEWconnectServiceConnectionTypeStun                   = 0,
  MEWconnectServiceConnectionTypeTurn                   = 1,
};

typedef NS_ENUM(short, MEWconnectServiceConnectionState) {
  // General flow
  MEWconnectServiceConnectionStateDisconnected          = 0, //Disconnected
  MEWconnectServiceConnectionStateConnected             = 1, //MEWRTC: connected, after first message
  MEWconnectServiceConnectionStateFailed                = 2, //MEWRTC: failed
  // Socket connection flow
  MEWconnectServiceConnectionStateSocketConnecting      = 3, //Socket: connecting
  MEWconnectServiceConnectionStateSocketConnected       = 4, //Socket: connected
  MEWconnectServiceConnectionStateSocketClosed          = 5, //Socket: closed, after success connection
  // MEW flow
  MEWconnectServiceConnectionStateMEWConnecting         = 6, //MEW: connecting
  MEWconnectServiceConnectionStateMEWHandshake          = 7, //MEW: handshake
  // WebRTC flow
  MEWconnectServiceConnectionStateMEWRTCConnecting      = 8, //MEWRTC: connecting
  MEWconnectServiceConnectionStateMEWRTCRemoteUpdated   = 9, //MEWRTC: did set remote description
  MEWconnectServiceConnectionStateMEWRTCAnswerPreparing = 10, //MEWRTC: preparing answer
  MEWconnectServiceConnectionStateMEWRTCLocalUpdated    = 11, //MEWRTC: did set local description
  MEWconnectServiceConnectionStateMEWRTCAnswerPrepared  = 12, //MEWRTC: answer did prepared
  MEWconnectServiceConnectionStateMEWRTCConnected       = 13, //MEWRTC: connected
  // WebRTC data channel flow
  MEWconnectServiceConnectionStateDataChannelConnecting = 14, //MEWRTC: data channel connecting
  MEWconnectServiceConnectionStateDataChannelOpened     = 15, //MEWRTC: data channel was opened
};
