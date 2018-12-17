//
//  _MasterTokenPlainObject.m
//
// DO NOT EDIT. This file is machine-generated and constantly overwritten.
//

#import "_MasterTokenPlainObject.h"
#import "MasterTokenPlainObject.h"

@implementation _MasterTokenPlainObject

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
  
    [aCoder encodeObject:self.fromNetworkMaster forKey:@"fromNetworkMaster"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self != nil) {

        _fromNetworkMaster = [[aDecoder decodeObjectForKey:@"fromNetworkMaster"] copy];
    }

    return self;
}

#pragma mark NSCopying

- (id)copyWithZone:(NSZone *)zone {
    MasterTokenPlainObject *replica = [[[self class] allocWithZone:zone] init];

    replica.fromNetworkMaster = self.fromNetworkMaster;
  
    replica.address = self.address;
    replica.balance = self.balance;
    replica.decimals = self.decimals;
    replica.name = self.name;
    replica.symbol = self.symbol;
    
    replica.fromNetwork = self.fromNetwork;
    replica.price = self.price;
    replica.purchaseHistory = self.purchaseHistory;

    return replica;
}

@end
