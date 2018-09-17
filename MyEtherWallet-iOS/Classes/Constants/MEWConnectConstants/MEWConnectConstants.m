//
//  MEWConnectConstants.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 24/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "MEWConnectConstants.h"

/* MEWConnect config keys */

NSString *const kMEWConnectSocketConfigLog                = @"log";
NSString *const kMEWConnectSocketConfigCompress           = @"compress";
NSString *const kMEWConnectSocketConfigSecure             = @"secure";
NSString *const kMEWConnectSocketConfigSelfSigned         = @"selfSigned";
NSString *const kMEWConnectSocketConfigSessionDelegate    = @"sessionDelegate";
NSString *const kMEWConnectSocketConfigConnectParams      = @"connectParams";
NSString *const kMEWConnectSocketConfigConnId             = @"connId";
NSString *const kMEWConnectSocketConfigKey                = @"key";
NSString *const kMEWConnectSocketConfigStage              = @"stage";

/* MEWConnect config values */

NSString *const MEWConnectSocketReceiver                  = @"receiver";

/* MEWConnect signals */

NSString *const kMEWConnectSignalConnect                  = @"connect";
NSString *const kMEWConnectSignalHandshake                = @"handshake";
NSString *const kMEWConnectSignalOffer                    = @"offer";
NSString *const kMEWConnectSignalAnswer                   = @"answer";
NSString *const kMEWConnectSignalError                    = @"error";
NSString *const kMEWConnectSignalInvalidConnection        = @"InvalidConnection";
NSString *const kMEWConnectSignalConfirmationFailed       = @"confirmationFailed";

/* MEWConnect data keys */

NSString *const kMEWConnectSocketData                     = @"data";
NSString *const kMEWConnectSocketToSign                   = @"toSign";
NSString *const kMEWConnectSocketType                     = @"type";
NSString *const kMEWConnectSocketSDP                      = @"sdp";

/* MEWConnect emit */

NSString *const kMEWConnectEmitSignature                  = @"signature";
NSString *const kMEWConnectEmitAnswerSignal               = @"answerSignal";
NSString *const kMEWConnectEmitTryTurn                    = @"tryTurn";
NSString *const kMEWConnectEmitRTCConnected               = @"rtcConnected";

/* MEWConnect message keys */

NSString *const kMEWConnectMessageConnId                  = @"connId";
NSString *const kMEWConnectMessageSigned                  = @"signed";
NSString *const kMEWConnectMessageVersion                 = @"version";
NSString *const kMEWConnectMessageData                    = @"data";
NSString *const kMEWConnectMessageCont                    = @"cont";
