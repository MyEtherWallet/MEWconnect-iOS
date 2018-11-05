//
//  _Token.h
//
//
// DO NOT EDIT. This file is machine-generated and constantly overwritten.
//

@import Foundation;

@class NetworkPlainObject;
@class FiatPricePlainObject;
@class PurchaseHistoryPlainObject;

@interface _TokenPlainObject : NSObject <NSCoding, NSCopying>

@property (nonatomic, copy, readwrite) NSString *address;
@property (nonatomic, copy, readwrite) NSDecimalNumber *balance;
@property (nonatomic, copy, readwrite) NSNumber *decimals;
@property (nonatomic, copy, readwrite) NSString *name;
@property (nonatomic, copy, readwrite) NSString *symbol;

@property (nonatomic, copy, readwrite) NetworkPlainObject *fromNetwork;

@property (nonatomic, copy, readwrite) FiatPricePlainObject *price;

@property (nonatomic, copy, readwrite) NSSet<PurchaseHistoryPlainObject *> *purchaseHistory;

@end
