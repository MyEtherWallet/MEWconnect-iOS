//
//  SimplexService.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 03/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

#import "SimplexServiceCurrencyTypes.h"

@class AccountPlainObject;
@class PurchaseHistoryModelObject;
@class PurchaseHistoryPlainObject;
@class SimplexQuote;
@class SimplexOrder;

typedef void(^SimplexServiceQuoteCompletion)(SimplexQuote *quote, NSError *error);
typedef void(^SimplexServiceOrderCompletion)(SimplexOrder *order, NSError *error);
typedef void(^SimplexServiceStatusCompletion)(NSError *error);

@protocol SimplexService <NSObject>
- (void) quoteForAccount:(AccountPlainObject *)account amount:(NSDecimalNumber *)amount currency:(SimplexServiceCurrencyType)currency completion:(SimplexServiceQuoteCompletion)completion;
- (void) orderForAccount:(AccountPlainObject *)account quote:(SimplexQuote *)quote completion:(SimplexServiceOrderCompletion)completion;
- (void) statusForPurchase:(PurchaseHistoryPlainObject *)purchase completion:(SimplexServiceStatusCompletion)completion;
- (NSArray <PurchaseHistoryModelObject *> *) obtainHistoryForAccount:(AccountPlainObject *)account;
- (NSURLRequest *) obtainRequestWithOrder:(SimplexOrder *)order forAccount:(AccountPlainObject *)account;
@end
