//
//  BuyEtherHistoryCellObjectBuilder.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 06/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "BuyEtherHistoryCellObjectBuilder.h"

#import "BuyEtherHistoryItemTableViewCellObject.h"
#import "BuyEtherHistoryEmptyTableViewCellObject.h"

@implementation BuyEtherHistoryCellObjectBuilder

- (NSArray<BuyEtherHistoryItemTableViewCellObject *> *) buildCellObjectsForHistoryItems:(NSArray<PurchaseHistoryPlainObject *> *)items {
  NSMutableArray <BuyEtherHistoryItemTableViewCellObject *> *objects = [[NSMutableArray alloc] initWithCapacity:[items count]];
  for (PurchaseHistoryPlainObject *historyItem in items) {
    [objects addObject:[self buildCellObjectForHistoryItem:historyItem]];
  }
  return [objects copy];
}

- (BuyEtherHistoryItemTableViewCellObject *) buildCellObjectForHistoryItem:(PurchaseHistoryPlainObject *)historyItem {
  BuyEtherHistoryItemTableViewCellObject *object = [BuyEtherHistoryItemTableViewCellObject objectWithPurchaseHistoryItem:historyItem];
  return object;
}

- (BuyEtherHistoryEmptyTableViewCellObject *)buildEmptyCellObject {
  return [BuyEtherHistoryEmptyTableViewCellObject object];
}
@end
