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

@interface BuyEtherHistoryCellObjectBuilder : NSObject
//TODO
- (NSArray <BuyEtherHistoryItemTableViewCellObject *> *) buildCellObjectsForHistoryItems:(NSArray *)items;
- (BuyEtherHistoryEmptyTableViewCellObject *) buildEmptyCellObject;
@end
