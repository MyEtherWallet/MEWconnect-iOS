//
//  TransactionViewInput.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@class MEWConnectTransaction;
@class AccountPlainObject;

@protocol TransactionViewInput <NSObject>
- (void) setupInitialState;
- (void) updateWithTransaction:(MEWConnectTransaction *)transaction forAccount:(AccountPlainObject *)account;
- (void) enableSign:(BOOL)enable;
@end
