//
//  _NetworkPlainObject.m
//
// DO NOT EDIT. This file is machine-generated and constantly overwritten.
//

#import "_NetworkPlainObject.h"
#import "NetworkPlainObject.h"

@implementation _NetworkPlainObject

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder {

    [aCoder encodeObject:self.active forKey:@"active"];
    [aCoder encodeObject:self.chainID forKey:@"chainID"];
    [aCoder encodeObject:self.accounts forKey:@"accounts"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self != nil) {

        _active = [[aDecoder decodeObjectForKey:@"active"] copy];
        _chainID = [[aDecoder decodeObjectForKey:@"chainID"] copy];
        _accounts = [[aDecoder decodeObjectForKey:@"accounts"] copy];
    }

    return self;
}

#pragma mark NSCopying

- (id)copyWithZone:(NSZone *)zone {
    NetworkPlainObject *replica = [[[self class] allocWithZone:zone] init];

    replica.active = self.active;
    replica.chainID = self.chainID;

    replica.accounts = self.accounts;

    return replica;
}

@end
