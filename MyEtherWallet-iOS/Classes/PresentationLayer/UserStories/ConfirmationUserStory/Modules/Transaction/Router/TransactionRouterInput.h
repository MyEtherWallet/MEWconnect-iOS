//
//  TransactionRouterInput.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@protocol ContextPasswordModuleOutput;
@protocol ConfirmationStoryModuleOutput;
@class AccountPlainObject;

#import "ConfirmationNavigationModuleInput.h"

@protocol TransactionRouterInput <NSObject>
- (void) openConfirmedTransactionWithConfirmationDelegate:(id<ConfirmationStoryModuleOutput>)confirmationDelegate;
- (void) openDeclinedTransactionWithConfirmationDelegate:(id<ConfirmationStoryModuleOutput>)confirmationDelegate;
- (void) close;
- (void) openContextPasswordWithAccount:(AccountPlainObject *)account moduleOutput:(id <ContextPasswordModuleOutput>)output;
@end
