//
//  _Account.h
//
//
// DO NOT EDIT. This file is machine-generated and constantly overwritten.
//

@import Foundation;

@class NetworkPlainObject;
@class FiatPricePlainObject;
@class PurchaseHistoryPlainObject;
@class TokenPlainObject;

@interface _AccountPlainObject : NSObject <NSCoding, NSCopying>

@property (nonatomic, copy, readwrite) NSNumber *active;
@property (nonatomic, copy, readwrite) NSNumber *backedUp;
@property (nonatomic, copy, readwrite) NSDecimalNumber *balance;
@property (nonatomic, copy, readwrite) NSNumber *decimals;
@property (nonatomic, copy, readwrite) NSString *publicAddress;

@property (nonatomic, copy, readwrite) NetworkPlainObject *fromNetwork;

@property (nonatomic, copy, readwrite) FiatPricePlainObject *price;

@property (nonatomic, copy, readwrite) NSSet<PurchaseHistoryPlainObject *> *purchaseHistory;

@property (nonatomic, copy, readwrite) NSSet<TokenPlainObject *> *tokens;

@end
