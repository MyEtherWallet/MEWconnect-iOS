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

@dynamic fromAccount;

@dynamic price;

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
+ (NSString *)fromAccount {
	return @"fromAccount";
}
+ (NSString *)price {
	return @"price";
}
@end

