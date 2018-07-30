//
//  MEWRTCServiceDelegate.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 24/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@protocol MEWRTCService;

@protocol MEWRTCServiceDelegate <NSObject>
//- (void) MEWRTCService:(id <MEWRTCService>)rtcService didGenerateAnswer:(RTCSessionDescription *)answer;
- (void) MEWRTCService:(id <MEWRTCService>)rtcService didGenerateAnswerWithType:(NSString *)type sdp:(NSString *)sdp;
- (void) MEWRTCServiceConnectionDidFailed:(id <MEWRTCService>)rtcService;
- (void) MEWRTCServiceConnectionDidConnected:(id <MEWRTCService>)rtcService;
- (void) MEWRTCServiceConnectionDidDisconnected:(id <MEWRTCService>)rtcService;
- (void) MEWRTCServiceDataChannelDidOpen:(id <MEWRTCService>)rtcService;
- (void) MEWRTCService:(id <MEWRTCService>)rtcService didReceiveMessage:(NSDictionary *)message;
@end
