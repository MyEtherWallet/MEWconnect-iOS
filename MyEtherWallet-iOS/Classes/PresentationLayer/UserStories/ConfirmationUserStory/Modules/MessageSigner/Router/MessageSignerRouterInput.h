//
//  MessageSignerRouterInput.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 03/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@protocol SplashPasswordModuleOutput;
@protocol ConfirmationStoryModuleOutput;
@class AccountPlainObject;

@protocol MessageSignerRouterInput <NSObject>
- (void) openConfirmedMessageWithConfirmationDelegate:(id<ConfirmationStoryModuleOutput>)confirmationDelegate;
- (void) close;
- (void) openSplashPasswordWithAccount:(AccountPlainObject *)account moduleOutput:(id <SplashPasswordModuleOutput>)output;

@end
