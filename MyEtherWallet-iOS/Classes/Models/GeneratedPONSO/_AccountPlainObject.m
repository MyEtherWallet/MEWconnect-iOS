//
//  _AccountPlainObject.m
//
// DO NOT EDIT. This file is machine-generated and constantly overwritten.
//

#import "_AccountPlainObject.h"
#import "AccountPlainObject.h"

@implementation _AccountPlainObject

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder {

    [aCoder encodeObject:self.active forKey:@"active"];
    [aCoder encodeObject:self.backedUp forKey:@"backedUp"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.uid forKey:@"uid"];
    [aCoder encodeObject:self.networks forKey:@"networks"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self != nil) {

        _active = [[aDecoder decodeObjectForKey:@"active"] copy];
        _backedUp = [[aDecoder decodeObjectForKey:@"backedUp"] copy];
        _name = [[aDecoder decodeObjectForKey:@"name"] copy];
        _uid = [[aDecoder decodeObjectForKey:@"uid"] copy];
        _networks = [[aDecoder decodeObjectForKey:@"networks"] copy];
    }

    return self;
}

#pragma mark NSCopying

- (id)copyWithZone:(NSZone *)zone {
    AccountPlainObject *replica = [[[self class] allocWithZone:zone] init];

    replica.active = self.active;
    replica.backedUp = self.backedUp;
    replica.name = self.name;
    replica.uid = self.uid;

    replica.networks = self.networks;

    return replica;
}

@end
