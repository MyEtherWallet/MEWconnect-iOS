// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to PurchaseHistoryModelObject.m instead.

#import "_PurchaseHistoryModelObject.h"

@implementation PurchaseHistoryModelObjectID
@end

@implementation _PurchaseHistoryModelObject

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"PurchaseHistory" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"PurchaseHistory";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"PurchaseHistory" inManagedObjectContext:moc_];
}

- (PurchaseHistoryModelObjectID*)objectID {
	return (PurchaseHistoryModelObjectID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"loadedValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"loaded"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic amount;

@dynamic date;

@dynamic loaded;

- (BOOL)loadedValue {
	NSNumber *result = [self loaded];
	return [result boolValue];
}

- (void)setLoadedValue:(BOOL)value_ {
	[self setLoaded:@(value_)];
}

- (BOOL)primitiveLoadedValue {
	NSNumber *result = [self primitiveLoaded];
	return [result boolValue];
}

- (void)setPrimitiveLoadedValue:(BOOL)value_ {
	[self setPrimitiveLoaded:@(value_)];
}

@dynamic transactionId;

@dynamic fromAccount;

@end

@implementation PurchaseHistoryModelObjectAttributes 
+ (NSString *)amount {
	return @"amount";
}
+ (NSString *)date {
	return @"date";
}
+ (NSString *)loaded {
	return @"loaded";
}
+ (NSString *)transactionId {
	return @"transactionId";
}
@end

@implementation PurchaseHistoryModelObjectRelationships 
+ (NSString *)fromAccount {
	return @"fromAccount";
}
@end

