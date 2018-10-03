//
//  MEWConnectServiceImplementation.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 24/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "MEWConnectService.h"
#import "MEWConnectServiceDelegate.h"

@protocol MEWcrypto;
@protocol MEWRTCService;
@protocol ResponseMapper;
@class MEWconnectServiceStateMachine;

@interface MEWConnectServiceImplementation : NSObject <MEWConnectService>
@property (nonatomic, weak) id <MEWConnectServiceDelegate> delegate;
@property (nonatomic, strong) id <MEWRTCService> rtcService;
@property (nonatomic, strong) id <MEWcrypto> MEWcrypto;
@property (nonatomic, strong) id <ResponseMapper> messageMapper;
@property (nonatomic, strong) MEWconnectServiceStateMachine *stateMachine;
@property (nonatomic, strong) NSURL *signallingServerURL;
- (instancetype) initWithMapper:(id <ResponseMapper>)mapper;
@end
