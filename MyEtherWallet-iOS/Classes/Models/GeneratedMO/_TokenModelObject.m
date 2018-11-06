// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TokenModelObject.m instead.

#import "_TokenModelObject.h"

@implementation TokenModelObjectID
@end

@implementation _TokenModelObject

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Token" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Token";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Token" inManagedObjectContext:moc_];
}

- (TokenModelObjectID*)objectID {
	return (TokenModelObjectID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"decimalsValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"decimals"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic address;

@dynamic balance;

@dynamic decimals;

- (int16_t)decimalsValue {
	NSNumber *result = [self decimals];
	return [result shortValue];
}

- (void)setDecimalsValue:(int16_t)value_ {
	[self setDecimals:@(value_)];
}

- (int16_t)primitiveDecimalsValue {
	NSNumber *result = [self primitiveDecimals];
	return [result shortValue];
}

- (void)setPrimitiveDecimalsValue:(int16_t)value_ {
	[self setPrimitiveDecimals:@(value_)];
}

@dynamic name;

@dynamic symbol;

@dynamic fromNetwork;

@dynamic price;

@dynamic purchaseHistory;

- (NSMutableOrderedSet<PurchaseHistoryModelObject*>*)purchaseHistorySet {
	[self willAccessValueForKey:@"purchaseHistory"];

	NSMutableOrderedSet<PurchaseHistoryModelObject*> *result = (NSMutableOrderedSet<PurchaseHistoryModelObject*>*)[self mutableOrderedSetValueForKey:@"purchaseHistory"];

	[self didAccessValueForKey:@"purchaseHistory"];
	return result;
}

@end

@implementation _TokenModelObject (PurchaseHistoryCoreDataGeneratedAccessors)
- (void)addPurchaseHistory:(NSOrderedSet<PurchaseHistoryModelObject*>*)value_ {
	[self.purchaseHistorySet unionOrderedSet:value_];
}
- (void)removePurchaseHistory:(NSOrderedSet<PurchaseHistoryModelObject*>*)value_ {
	[self.purchaseHistorySet minusOrderedSet:value_];
}
- (void)addPurchaseHistoryObject:(PurchaseHistoryModelObject*)value_ {
	[self.purchaseHistorySet addObject:value_];
}
- (void)removePurchaseHistoryObject:(PurchaseHistoryModelObject*)value_ {
	[self.purchaseHistorySet removeObject:value_];
}
- (void)insertObject:(PurchaseHistoryModelObject*)value inPurchaseHistoryAtIndex:(NSUInteger)idx {
    NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
    [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"purchaseHistory"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self purchaseHistory] ?: [NSOrderedSet orderedSet]];
    [tmpOrderedSet insertObject:value atIndex:idx];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"purchaseHistory"];
    [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"purchaseHistory"];
}
- (void)removeObjectFromPurchaseHistoryAtIndex:(NSUInteger)idx {
    NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
    [self willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"purchaseHistory"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self purchaseHistory] ?: [NSOrderedSet orderedSet]];
    [tmpOrderedSet removeObjectAtIndex:idx];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"purchaseHistory"];
    [self didChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"purchaseHistory"];
}
- (void)insertPurchaseHistory:(NSArray *)value atIndexes:(NSIndexSet *)indexes {
    [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"purchaseHistory"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self purchaseHistory] ?: [NSOrderedSet orderedSet]];
    [tmpOrderedSet insertObjects:value atIndexes:indexes];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"purchaseHistory"];
    [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"purchaseHistory"];
}
- (void)removePurchaseHistoryAtIndexes:(NSIndexSet *)indexes {
    [self willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"purchaseHistory"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self purchaseHistory] ?: [NSOrderedSet orderedSet]];
    [tmpOrderedSet removeObjectsAtIndexes:indexes];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"purchaseHistory"];
    [self didChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"purchaseHistory"];
}
- (void)replaceObjectInPurchaseHistoryAtIndex:(NSUInteger)idx withObject:(PurchaseHistoryModelObject*)value {
    NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
    [self willChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"purchaseHistory"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self purchaseHistory] ?: [NSOrderedSet orderedSet]];
    [tmpOrderedSet replaceObjectAtIndex:idx withObject:value];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"purchaseHistory"];
    [self didChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"purchaseHistory"];
}
- (void)replacePurchaseHistoryAtIndexes:(NSIndexSet *)indexes withPurchaseHistory:(NSArray *)value {
    [self willChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"purchaseHistory"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self purchaseHistory] ?: [NSOrderedSet orderedSet]];
    [tmpOrderedSet replaceObjectsAtIndexes:indexes withObjects:value];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"purchaseHistory"];
    [self didChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"purchaseHistory"];
}
@end

@implementation TokenModelObjectAttributes 
+ (NSString *)address {
	return @"address";
}
+ (NSString *)balance {
	return @"balance";
}
+ (NSString *)decimals {
	return @"decimals";
}
+ (NSString *)name {
	return @"name";
}
+ (NSString *)symbol {
	return @"symbol";
}
@end

@implementation TokenModelObjectRelationships 
+ (NSString *)fromNetwork {
	return @"fromNetwork";
}
+ (NSString *)price {
	return @"price";
}
+ (NSString *)purchaseHistory {
	return @"purchaseHistory";
}
@end

