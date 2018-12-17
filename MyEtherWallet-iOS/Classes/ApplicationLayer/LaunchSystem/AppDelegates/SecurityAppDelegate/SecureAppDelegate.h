//
//  SecurityAppDelegate.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 06/11/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import UIKit;

@class SecureRouter;
@protocol SecureService;

NS_ASSUME_NONNULL_BEGIN

@interface SecurityAppDelegate : NSObject <UIApplicationDelegate>
@property (nonatomic, strong) SecureRouter *secureRouter;
@property (nonatomic, strong) id <SecureService> secureService;
@end

NS_ASSUME_NONNULL_END
