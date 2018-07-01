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
    [aCoder encodeObject:self.balance forKey:@"balance"];
    [aCoder encodeObject:self.decimals forKey:@"decimals"];
    [aCoder encodeObject:self.publicAddress forKey:@"publicAddress"];
    [aCoder encodeObject:self.fromNetwork forKey:@"fromNetwork"];
    [aCoder encodeObject:self.price forKey:@"price"];
    [aCoder encodeObject:self.tokens forKey:@"tokens"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self != nil) {

        _active = [[aDecoder decodeObjectForKey:@"active"] copy];
        _backedUp = [[aDecoder decodeObjectForKey:@"backedUp"] copy];
        _balance = [[aDecoder decodeObjectForKey:@"balance"] copy];
        _decimals = [[aDecoder decodeObjectForKey:@"decimals"] copy];
        _publicAddress = [[aDecoder decodeObjectForKey:@"publicAddress"] copy];
        _fromNetwork = [[aDecoder decodeObjectForKey:@"fromNetwork"] copy];
        _price = [[aDecoder decodeObjectForKey:@"price"] copy];
        _tokens = [[aDecoder decodeObjectForKey:@"tokens"] copy];
    }

    return self;
}

#pragma mark NSCopying

- (id)copyWithZone:(NSZone *)zone {
    AccountPlainObject *replica = [[[self class] allocWithZone:zone] init];

    replica.active = self.active;
    replica.backedUp = self.backedUp;
    replica.balance = self.balance;
    replica.decimals = self.decimals;
    replica.publicAddress = self.publicAddress;

    replica.fromNetwork = self.fromNetwork;
    replica.price = self.price;
    replica.tokens = self.tokens;

    return replica;
}

@end
