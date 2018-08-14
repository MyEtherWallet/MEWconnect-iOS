// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to NetworkModelObject.m instead.

#import "_NetworkModelObject.h"

@implementation NetworkModelObjectID
@end

@implementation _NetworkModelObject

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Network" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Network";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Network" inManagedObjectContext:moc_];
}

- (NetworkModelObjectID*)objectID {
	return (NetworkModelObjectID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"activeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"active"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"chainIDValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"chainID"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic active;

- (BOOL)activeValue {
	NSNumber *result = [self active];
	return [result boolValue];
}

- (void)setActiveValue:(BOOL)value_ {
	[self setActive:@(value_)];
}

- (BOOL)primitiveActiveValue {
	NSNumber *result = [self primitiveActive];
	return [result boolValue];
}

- (void)setPrimitiveActiveValue:(BOOL)value_ {
	[self setPrimitiveActive:@(value_)];
}

@dynamic chainID;

- (int16_t)chainIDValue {
	NSNumber *result = [self chainID];
	return [result shortValue];
}

- (void)setChainIDValue:(int16_t)value_ {
	[self setChainID:@(value_)];
}

- (int16_t)primitiveChainIDValue {
	NSNumber *result = [self primitiveChainID];
	return [result shortValue];
}

- (void)setPrimitiveChainIDValue:(int16_t)value_ {
	[self setPrimitiveChainID:@(value_)];
}

@dynamic accounts;

- (NSMutableOrderedSet<AccountModelObject*>*)accountsSet {
	[self willAccessValueForKey:@"accounts"];

	NSMutableOrderedSet<AccountModelObject*> *result = (NSMutableOrderedSet<AccountModelObject*>*)[self mutableOrderedSetValueForKey:@"accounts"];

	[self didAccessValueForKey:@"accounts"];
	return result;
}

@end

@implementation _NetworkModelObject (AccountsCoreDataGeneratedAccessors)
- (void)addAccounts:(NSOrderedSet<AccountModelObject*>*)value_ {
	[self.accountsSet unionOrderedSet:value_];
}
- (void)removeAccounts:(NSOrderedSet<AccountModelObject*>*)value_ {
	[self.accountsSet minusOrderedSet:value_];
}
- (void)addAccountsObject:(AccountModelObject*)value_ {
	[self.accountsSet addObject:value_];
}
- (void)removeAccountsObject:(AccountModelObject*)value_ {
	[self.accountsSet removeObject:value_];
}
- (void)insertObject:(AccountModelObject*)value inAccountsAtIndex:(NSUInteger)idx {
    NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
    [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"accounts"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self accounts] ?: [NSOrderedSet orderedSet]];
    [tmpOrderedSet insertObject:value atIndex:idx];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"accounts"];
    [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"accounts"];
}
- (void)removeObjectFromAccountsAtIndex:(NSUInteger)idx {
    NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
    [self willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"accounts"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self accounts] ?: [NSOrderedSet orderedSet]];
    [tmpOrderedSet removeObjectAtIndex:idx];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"accounts"];
    [self didChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"accounts"];
}
- (void)insertAccounts:(NSArray *)value atIndexes:(NSIndexSet *)indexes {
    [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"accounts"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self accounts] ?: [NSOrderedSet orderedSet]];
    [tmpOrderedSet insertObjects:value atIndexes:indexes];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"accounts"];
    [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"accounts"];
}
- (void)removeAccountsAtIndexes:(NSIndexSet *)indexes {
    [self willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"accounts"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self accounts] ?: [NSOrderedSet orderedSet]];
    [tmpOrderedSet removeObjectsAtIndexes:indexes];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"accounts"];
    [self didChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"accounts"];
}
- (void)replaceObjectInAccountsAtIndex:(NSUInteger)idx withObject:(AccountModelObject*)value {
    NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
    [self willChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"accounts"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self accounts] ?: [NSOrderedSet orderedSet]];
    [tmpOrderedSet replaceObjectAtIndex:idx withObject:value];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"accounts"];
    [self didChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"accounts"];
}
- (void)replaceAccountsAtIndexes:(NSIndexSet *)indexes withAccounts:(NSArray *)value {
    [self willChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"accounts"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self accounts] ?: [NSOrderedSet orderedSet]];
    [tmpOrderedSet replaceObjectsAtIndexes:indexes withObjects:value];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"accounts"];
    [self didChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"accounts"];
}
@end

@implementation NetworkModelObjectAttributes 
+ (NSString *)active {
	return @"active";
}
+ (NSString *)chainID {
	return @"chainID";
}
@end

@implementation NetworkModelObjectRelationships 
+ (NSString *)accounts {
	return @"accounts";
}
@end

