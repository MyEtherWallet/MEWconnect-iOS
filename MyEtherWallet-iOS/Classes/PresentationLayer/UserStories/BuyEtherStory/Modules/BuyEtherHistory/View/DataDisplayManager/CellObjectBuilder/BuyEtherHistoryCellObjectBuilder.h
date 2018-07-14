//
//  BuyEtherHistoryCellObjectBuilder.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 06/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@class BuyEtherHistoryItemTableViewCellObject;
@class BuyEtherHistoryEmptyTableViewCellObject;
@class PurchaseHistoryPlainObject;

@interface BuyEtherHistoryCellObjectBuilder : NSObject
- (NSArray <BuyEtherHistoryItemTableViewCellObject *> *) buildCellObjectsForHistoryItems:(NSArray <PurchaseHistoryPlainObject *> *)items;
- (BuyEtherHistoryItemTableViewCellObject *) buildCellObjectForHistoryItem:(PurchaseHistoryPlainObject *)historyItem;
- (BuyEtherHistoryEmptyTableViewCellObject *) buildEmptyCellObject;
@end
