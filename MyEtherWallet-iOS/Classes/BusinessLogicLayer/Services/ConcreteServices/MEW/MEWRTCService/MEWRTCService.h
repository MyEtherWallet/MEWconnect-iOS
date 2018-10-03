//
//  MEWRTCService.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 24/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@protocol MEWRTCServiceDelegate;
@class RTCSessionDescription;

@protocol MEWRTCService <NSObject>
@property (nonatomic, weak) id <MEWRTCServiceDelegate> delegate;
- (void) connectWithType:(NSString *)type andSdp:(NSString *)sdp;
- (void) prepareAnswer;
- (void) updateLocalDescriptionWithAnswer:(RTCSessionDescription *)answer;
- (void) openDataChannel;
- (void) disconnect;
- (BOOL) sendMessage:(id)message;
@end
