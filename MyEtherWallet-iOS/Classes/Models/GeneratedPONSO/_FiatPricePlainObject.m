//
//  _FiatPricePlainObject.m
//
// DO NOT EDIT. This file is machine-generated and constantly overwritten.
//

#import "_FiatPricePlainObject.h"
#import "FiatPricePlainObject.h"

@implementation _FiatPricePlainObject

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder {

    [aCoder encodeObject:self.usdPrice forKey:@"usdPrice"];
    [aCoder encodeObject:self.fromToken forKey:@"fromToken"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self != nil) {

        _usdPrice = [[aDecoder decodeObjectForKey:@"usdPrice"] copy];
        _fromToken = [[aDecoder decodeObjectForKey:@"fromToken"] copy];
    }

    return self;
}

#pragma mark NSCopying

- (id)copyWithZone:(NSZone *)zone {
    FiatPricePlainObject *replica = [[[self class] allocWithZone:zone] init];

    replica.usdPrice = self.usdPrice;

    replica.fromToken = self.fromToken;

    return replica;
}

@end
