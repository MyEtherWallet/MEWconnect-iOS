//
//  MEWConnectConstants.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 24/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

/* MEWConnect config keys */

FOUNDATION_EXPORT NSString *const kMEWConnectSocketConfigLog;
FOUNDATION_EXPORT NSString *const kMEWConnectSocketConfigCompress;
FOUNDATION_EXPORT NSString *const kMEWConnectSocketConfigSecure;
FOUNDATION_EXPORT NSString *const kMEWConnectSocketConfigSelfSigned;
FOUNDATION_EXPORT NSString *const kMEWConnectSocketConfigSessionDelegate;
FOUNDATION_EXPORT NSString *const kMEWConnectSocketConfigConnectParams;
FOUNDATION_EXPORT NSString *const kMEWConnectSocketConfigConnId;
FOUNDATION_EXPORT NSString *const kMEWConnectSocketConfigKey;
FOUNDATION_EXPORT NSString *const kMEWConnectSocketConfigStage;

/* MEWConnect config values */

FOUNDATION_EXPORT NSString *const MEWConnectSocketReceiver;

/* MEWConnect signals */

FOUNDATION_EXPORT NSString *const kMEWConnectSignalConnect;
FOUNDATION_EXPORT NSString *const kMEWConnectSignalHandshake;
FOUNDATION_EXPORT NSString *const kMEWConnectSignalOffer;
FOUNDATION_EXPORT NSString *const kMEWConnectSignalAnswer;
FOUNDATION_EXPORT NSString *const kMEWConnectSignalError;
FOUNDATION_EXPORT NSString *const kMEWConnectSignalInvalidConnection;
FOUNDATION_EXPORT NSString *const kMEWConnectSignalConfirmationFailed;

/* MEWConnect data keys */

FOUNDATION_EXPORT NSString *const kMEWConnectSocketData;
FOUNDATION_EXPORT NSString *const kMEWConnectSocketToSign;
FOUNDATION_EXPORT NSString *const kMEWConnectSocketType;
FOUNDATION_EXPORT NSString *const kMEWConnectSocketSDP;

/* MEWConnect emit */

FOUNDATION_EXPORT NSString *const kMEWConnectEmitSignature;
FOUNDATION_EXPORT NSString *const kMEWConnectEmitAnswerSignal;
FOUNDATION_EXPORT NSString *const kMEWConnectEmitTryTurn;
FOUNDATION_EXPORT NSString *const kMEWConnectEmitRTCConnected;

/* MEWConnect message keys */

FOUNDATION_EXPORT NSString *const kMEWConnectMessageConnId;
FOUNDATION_EXPORT NSString *const kMEWConnectMessageSigned;
FOUNDATION_EXPORT NSString *const kMEWConnectMessageVersion;
FOUNDATION_EXPORT NSString *const kMEWConnectMessageData;
FOUNDATION_EXPORT NSString *const kMEWConnectMessageCont;
