//
//  _Token.h
//
//
// DO NOT EDIT. This file is machine-generated and constantly overwritten.
//

@import Foundation;

@class AccountPlainObject;
@class FiatPricePlainObject;

@interface _TokenPlainObject : NSObject <NSCoding, NSCopying>

@property (nonatomic, copy, readwrite) NSString *address;
@property (nonatomic, copy, readwrite) NSDecimalNumber *balance;
@property (nonatomic, copy, readwrite) NSNumber *decimals;
@property (nonatomic, copy, readwrite) NSString *name;
@property (nonatomic, copy, readwrite) NSString *symbol;

@property (nonatomic, copy, readwrite) AccountPlainObject *fromAccount;

@property (nonatomic, copy, readwrite) FiatPricePlainObject *price;

@end
