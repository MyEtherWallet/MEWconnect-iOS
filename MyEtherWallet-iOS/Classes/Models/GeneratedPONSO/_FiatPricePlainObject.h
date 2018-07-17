//
//  _FiatPrice.h
//
//
// DO NOT EDIT. This file is machine-generated and constantly overwritten.
//

@import Foundation;

@class AccountPlainObject;
@class TokenPlainObject;

@interface _FiatPricePlainObject : NSObject <NSCoding, NSCopying>

@property (nonatomic, copy, readwrite) NSDecimalNumber *usdPrice;

@property (nonatomic, copy, readwrite) NSSet<AccountPlainObject *> *fromAccount;

@property (nonatomic, copy, readwrite) NSSet<TokenPlainObject *> *fromToken;

@end
