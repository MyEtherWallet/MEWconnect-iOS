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

- (NSArray<BuyEtherHistoryItemTableViewCellObject *> *)buildCellObjectsForHistoryItems:(NSArray *)items {
  //TODO
  return nil;
}

- (BuyEtherHistoryEmptyTableViewCellObject *)buildEmptyCellObject {
  return [BuyEtherHistoryEmptyTableViewCellObject object];
}
@end
