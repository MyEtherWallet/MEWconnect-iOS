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

@dynamic fromAccount;

@dynamic master;

@dynamic tokens;

- (NSMutableSet<TokenModelObject*>*)tokensSet {
	[self willAccessValueForKey:@"tokens"];

	NSMutableSet<TokenModelObject*> *result = (NSMutableSet<TokenModelObject*>*)[self mutableSetValueForKey:@"tokens"];

	[self didAccessValueForKey:@"tokens"];
	return result;
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
+ (NSString *)fromAccount {
	return @"fromAccount";
}
+ (NSString *)master {
	return @"master";
}
+ (NSString *)tokens {
	return @"tokens";
}
@end

