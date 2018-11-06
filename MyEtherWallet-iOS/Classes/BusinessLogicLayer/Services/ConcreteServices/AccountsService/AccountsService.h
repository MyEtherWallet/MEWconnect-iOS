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
- (AccountModelObject *) obtainAccountWithAccount:(AccountPlainObject *)account;
- (AccountModelObject *) obtainActiveAccount;
- (AccountModelObject *) obtainOrCreateActiveAccount;
- (void) resetAccounts;
- (void) accountBackedUp:(AccountPlainObject *)account;
- (void) deleteAccount:(AccountPlainObject *)account;
@end
