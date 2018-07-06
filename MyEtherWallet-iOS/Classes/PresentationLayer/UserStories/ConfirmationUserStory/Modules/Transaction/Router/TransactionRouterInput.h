//
//  TransactionRouterInput.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@protocol SplashPasswordModuleOutput;
@class AccountPlainObject;

@protocol TransactionRouterInput <NSObject>
- (void) openConfirmedTransaction;
- (void) openDeclinedTransaction;
- (void) close;
- (void) openSplashPasswordWithAccount:(AccountPlainObject *)account moduleOutput:(id <SplashPasswordModuleOutput>)output;
@end
