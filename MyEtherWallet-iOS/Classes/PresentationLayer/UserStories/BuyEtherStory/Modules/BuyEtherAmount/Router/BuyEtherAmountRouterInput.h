//
//  BuyEtherAmountRouterInput.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 02/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@class SimplexOrder;
@class AccountPlainObject;

@protocol BuyEtherAmountRouterInput <NSObject>
- (void) openBuyEtherWebWithOrder:(SimplexOrder *)order account:(AccountPlainObject *)account;
- (void) openBuyEtherHistoryForAccount:(AccountPlainObject *)account;
- (void) close;
@end
