//
//  MEWConnectFacadeConstants.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 19/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "MEWConnectFacadeConstants.h"

NSString *const MEWConnectFacadeDidConnectNotification        = @"MEWConnectFacadeDidConnect";
NSString *const MEWConnectFacadeDidReceiveErrorNotification   = @"MEWConnectFacadeDidReceiveError";
NSString *const MEWConnectFacadeDidDisconnectNotification     = @"MEWConnectFacadeDidDisconnect";
NSString *const MEWConnectFacadeDidReceiveMessageNotification = @"MEWConnectFacadeDidReceiveMessage";

NSString *const kMEWConnectFacadeDisconnectReason             = @"reason";
NSString *const kMEWConnectFacadeMessage                      = @"message";

NSString *const kMEWConnectFacadeReasonClosed                 = @"closed";
NSString *const kMEWConnectFacadeReasonTimeout                = @"timeout";
NSString *const kMEWConnectFacadeReasonError                  = @"error";
