//
//  _PurchaseHistory.h
//
//
// DO NOT EDIT. This file is machine-generated and constantly overwritten.
//

@import Foundation;

@class TokenPlainObject;

@interface _PurchaseHistoryPlainObject : NSObject <NSCoding, NSCopying>

@property (nonatomic, copy, readwrite) NSDecimalNumber *amount;
@property (nonatomic, copy, readwrite) NSDate *date;
@property (nonatomic, copy, readwrite) NSNumber *loaded;
@property (nonatomic, copy, readwrite) NSNumber *status;
@property (nonatomic, copy, readwrite) NSString *userId;

@property (nonatomic, copy, readwrite) TokenPlainObject *fromToken;

@end
