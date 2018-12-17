//
//  TransactionInteractorInput.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@class AccountPlainObject;
@class MasterTokenPlainObject;
@class MEWConnectCommand;
@class MEWConnectTransaction;

@protocol TransactionInteractorInput <NSObject>
- (void) configurateWithMessage:(MEWConnectCommand *)message masterToken:(MasterTokenPlainObject *)masterToken;
- (MEWConnectTransaction *) obtainTransaction;
- (AccountPlainObject *) obtainAccount;
- (void) signTransactionWithPassword:(NSString *)password;
@end
