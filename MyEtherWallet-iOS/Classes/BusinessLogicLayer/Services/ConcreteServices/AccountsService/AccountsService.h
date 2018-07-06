//
//  AccountsService.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 27/06/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@class AccountModelObject;
@class AccountPlainObject;
@class NetworkPlainObject;

typedef void(^AccountsServiceCompletionBlock)(NSError *error);
typedef void(^AccountsServiceCreateCompletionBlock)(AccountModelObject *accountModelObject);

@protocol AccountsService <NSObject>
- (AccountModelObject *) obtainActiveAccount;
- (NSArray <AccountModelObject *> *) obtainAccountsOfActiveNetwork;
- (void) updateBalanceForAccount:(AccountPlainObject *)account withCompletion:(AccountsServiceCompletionBlock)completion;
//Account managing
- (void) createNewAccountInNetwork:(NetworkPlainObject *)network password:(NSString *)password words:(NSArray <NSString *> *)words completion:(AccountsServiceCreateCompletionBlock)completion;
- (BOOL) validatePassword:(NSString *)password forAccount:(AccountPlainObject *)account;
- (NSArray <NSString *> *) recoveryMnemonicsWordsForAccount:(AccountPlainObject *)account password:(NSString *)password;
- (void) accountBackedUp:(AccountPlainObject *)account;
- (NSArray <NSString *> *) bip32MnemonicsWords;
- (void) deleteAccount:(AccountPlainObject *)account;
@end
