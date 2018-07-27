//
//  HomeRouterInput.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@class MEWConnectCommand;
@class AccountPlainObject;
@protocol ConfirmationNavigationModuleInput;
@protocol ConfirmationStoryModuleOutput;

@protocol HomeRouterInput <NSObject>
- (void) openScanner;
- (void) openMessageSignerWithMessage:(MEWConnectCommand *)command;
- (id <ConfirmationNavigationModuleInput>) openTransactionSignerWithMessage:(MEWConnectCommand *)command account:(AccountPlainObject *)account confirmationDelegate:(id <ConfirmationStoryModuleOutput>)confirmationDelegate;
- (void) openBackupWithAccount:(AccountPlainObject *)account;
- (void) openInfoWithAccount:(AccountPlainObject *)account;
- (void) openBuyEtherWithAccount:(AccountPlainObject *)account;
- (void) unwindToStart;
@end
