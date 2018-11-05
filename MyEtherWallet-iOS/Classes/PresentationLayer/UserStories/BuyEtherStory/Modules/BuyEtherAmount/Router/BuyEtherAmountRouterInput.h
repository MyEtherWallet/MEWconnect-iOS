//
//  BuyEtherAmountRouterInput.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 02/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@class SimplexOrder;
@class MasterTokenPlainObject;

@protocol BuyEtherAmountRouterInput <NSObject>
- (void) openBuyEtherWebWithOrder:(SimplexOrder *)order masterToken:(MasterTokenPlainObject *)masterToken;
- (void) openBuyEtherHistoryForMasterToken:(MasterTokenPlainObject *)masterToken;
- (void) close;
@end
