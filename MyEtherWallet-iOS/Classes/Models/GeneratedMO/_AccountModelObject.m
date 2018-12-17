// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to AccountModelObject.m instead.

#import "_AccountModelObject.h"

@implementation AccountModelObjectID
@end

@implementation _AccountModelObject

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Account" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Account";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Account" inManagedObjectContext:moc_];
}

- (AccountModelObjectID*)objectID {
	return (AccountModelObjectID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"activeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"active"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"backedUpValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"backedUp"];
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

@dynamic backedUp;

- (BOOL)backedUpValue {
	NSNumber *result = [self backedUp];
	return [result boolValue];
}

- (void)setBackedUpValue:(BOOL)value_ {
	[self setBackedUp:@(value_)];
}

- (BOOL)primitiveBackedUpValue {
	NSNumber *result = [self primitiveBackedUp];
	return [result boolValue];
}

- (void)setPrimitiveBackedUpValue:(BOOL)value_ {
	[self setPrimitiveBackedUp:@(value_)];
}

@dynamic name;

@dynamic uid;

@dynamic networks;

- (NSMutableSet<NetworkModelObject*>*)networksSet {
	[self willAccessValueForKey:@"networks"];

	NSMutableSet<NetworkModelObject*> *result = (NSMutableSet<NetworkModelObject*>*)[self mutableSetValueForKey:@"networks"];

	[self didAccessValueForKey:@"networks"];
	return result;
}

@end

@implementation AccountModelObjectAttributes 
+ (NSString *)active {
	return @"active";
}
+ (NSString *)backedUp {
	return @"backedUp";
}
+ (NSString *)name {
	return @"name";
}
+ (NSString *)uid {
	return @"uid";
}
@end

@implementation AccountModelObjectRelationships 
+ (NSString *)networks {
	return @"networks";
}
@end

