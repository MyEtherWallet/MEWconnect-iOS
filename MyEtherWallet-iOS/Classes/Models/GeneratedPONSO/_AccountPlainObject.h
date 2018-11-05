//
//  _Account.h
//
//
// DO NOT EDIT. This file is machine-generated and constantly overwritten.
//

@import Foundation;

@class NetworkPlainObject;

@interface _AccountPlainObject : NSObject <NSCoding, NSCopying>

@property (nonatomic, copy, readwrite) NSNumber *active;
@property (nonatomic, copy, readwrite) NSNumber *backedUp;
@property (nonatomic, copy, readwrite) NSString *name;
@property (nonatomic, copy, readwrite) NSString *uid;

@property (nonatomic, copy, readwrite) NSSet<NetworkPlainObject *> *networks;

@end
