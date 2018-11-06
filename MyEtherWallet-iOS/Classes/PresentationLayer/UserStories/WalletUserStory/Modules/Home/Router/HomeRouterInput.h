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
@class MasterTokenPlainObject;
@protocol ConfirmationNavigationModuleInput;
@protocol ConfirmationStoryModuleOutput;
@protocol ContextPasswordModuleOutput;
@protocol RestoreSeedModuleOutput;

@protocol HomeRouterInput <NSObject>
- (void) openScanner;
- (void) openShareWithMasterToken:(MasterTokenPlainObject *)masterToken;
- (void) openContextPasswordWithOutput:(id <ContextPasswordModuleOutput>)output account:(AccountPlainObject *)account;
- (void) openRestoreSeedWithAccount:(AccountPlainObject *)account password:(NSString *)password moduleOutput:(id <RestoreSeedModuleOutput>)output;
- (id <ConfirmationNavigationModuleInput>) openMessageSignerWithMessage:(MEWConnectCommand *)command masterToken:(MasterTokenPlainObject *)masterToken confirmationDelegate:(id <ConfirmationStoryModuleOutput>)confirmationDelegate;
- (id <ConfirmationNavigationModuleInput>) openTransactionSignerWithMessage:(MEWConnectCommand *)command masterToken:(MasterTokenPlainObject *)masterToken confirmationDelegate:(id <ConfirmationStoryModuleOutput>)confirmationDelegate;
- (void) openBackupWithAccount:(AccountPlainObject *)account;
- (void) openInfo;
- (void) openBuyEtherWithMasterToken:(MasterTokenPlainObject *)masterToken;
- (void) unwindToStart;
@end
