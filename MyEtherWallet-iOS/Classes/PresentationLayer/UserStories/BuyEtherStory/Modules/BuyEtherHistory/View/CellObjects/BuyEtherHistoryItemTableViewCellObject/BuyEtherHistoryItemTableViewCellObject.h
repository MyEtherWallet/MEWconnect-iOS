//
//  BuyEtherHistoryItemTableViewCellObject.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 06/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;
@import Nimbus.NICellFactory;

#import "SimplexServiceStatusTypes.h"

@class PurchaseHistoryPlainObject;

@interface BuyEtherHistoryItemTableViewCellObject : NSObject <NINibCellObject>
@property (nonatomic, strong, readonly) NSString *date;
@property (nonatomic, strong, readonly) NSString *amount;
@property (nonatomic, readonly) SimplexServicePaymentStatusType status;
@property (nonatomic, strong, readonly) NSString *statusString;
+ (instancetype) objectWithPurchaseHistoryItem:(PurchaseHistoryPlainObject *)purchaseHistoryItem;
@end
