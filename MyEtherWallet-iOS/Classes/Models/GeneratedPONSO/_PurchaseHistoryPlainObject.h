//
//  _PurchaseHistory.h
//
//
// DO NOT EDIT. This file is machine-generated and constantly overwritten.
//

@import Foundation;

@class AccountPlainObject;

@interface _PurchaseHistoryPlainObject : NSObject <NSCoding, NSCopying>

@property (nonatomic, copy, readwrite) NSDecimalNumber *amount;
@property (nonatomic, copy, readwrite) NSDate *date;
@property (nonatomic, copy, readwrite) NSNumber *loaded;
@property (nonatomic, copy, readwrite) NSString *transactionId;

@property (nonatomic, copy, readwrite) AccountPlainObject *fromAccount;

@end
