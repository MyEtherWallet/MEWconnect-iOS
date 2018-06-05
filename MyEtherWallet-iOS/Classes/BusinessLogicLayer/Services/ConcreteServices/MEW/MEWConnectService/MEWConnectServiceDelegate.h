//
//  MEWConnectServiceDelegate.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 24/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MEWConnectService;

@class RTCSessionDescription;
@class MEWConnectCommand;

@protocol MEWConnectServiceDelegate <NSObject>
@optional
- (void) MEWConnectDidConnected:(id <MEWConnectService>)mewConnect;
- (void) MEWConnectDidReceiveError:(id <MEWConnectService>)mewConnect;
- (void) MEWConnect:(id <MEWConnectService>)mewConnect didReceiveMessage:(MEWConnectCommand *)message;
- (void) MEWConnectDidDisconnectedByTimeout:(id <MEWConnectService>)mewConnect;
@end
