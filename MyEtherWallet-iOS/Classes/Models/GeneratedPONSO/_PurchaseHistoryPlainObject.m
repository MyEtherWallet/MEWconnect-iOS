//
//  _PurchaseHistoryPlainObject.m
//
// DO NOT EDIT. This file is machine-generated and constantly overwritten.
//

#import "_PurchaseHistoryPlainObject.h"
#import "PurchaseHistoryPlainObject.h"

@implementation _PurchaseHistoryPlainObject

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder {

    [aCoder encodeObject:self.amount forKey:@"amount"];
    [aCoder encodeObject:self.date forKey:@"date"];
    [aCoder encodeObject:self.loaded forKey:@"loaded"];
    [aCoder encodeObject:self.transactionId forKey:@"transactionId"];
    [aCoder encodeObject:self.fromAccount forKey:@"fromAccount"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self != nil) {

        _amount = [[aDecoder decodeObjectForKey:@"amount"] copy];
        _date = [[aDecoder decodeObjectForKey:@"date"] copy];
        _loaded = [[aDecoder decodeObjectForKey:@"loaded"] copy];
        _transactionId = [[aDecoder decodeObjectForKey:@"transactionId"] copy];
        _fromAccount = [[aDecoder decodeObjectForKey:@"fromAccount"] copy];
    }

    return self;
}

#pragma mark NSCopying

- (id)copyWithZone:(NSZone *)zone {
    PurchaseHistoryPlainObject *replica = [[[self class] allocWithZone:zone] init];

    replica.amount = self.amount;
    replica.date = self.date;
    replica.loaded = self.loaded;
    replica.transactionId = self.transactionId;

    replica.fromAccount = self.fromAccount;

    return replica;
}

@end
