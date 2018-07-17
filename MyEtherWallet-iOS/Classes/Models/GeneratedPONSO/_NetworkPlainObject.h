//
//  _Network.h
//
//
// DO NOT EDIT. This file is machine-generated and constantly overwritten.
//

@import Foundation;

@class AccountPlainObject;

@interface _NetworkPlainObject : NSObject <NSCoding, NSCopying>

@property (nonatomic, copy, readwrite) NSNumber *active;
@property (nonatomic, copy, readwrite) NSNumber *chainID;

@property (nonatomic, copy, readwrite) NSSet<AccountPlainObject *> *accounts;

@end
