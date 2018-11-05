// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to FiatPriceModelObject.m instead.

#import "_FiatPriceModelObject.h"

@implementation FiatPriceModelObjectID
@end

@implementation _FiatPriceModelObject

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"FiatPrice" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"FiatPrice";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"FiatPrice" inManagedObjectContext:moc_];
}

- (FiatPriceModelObjectID*)objectID {
	return (FiatPriceModelObjectID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic usdPrice;

@dynamic fromToken;

- (NSMutableSet<TokenModelObject*>*)fromTokenSet {
	[self willAccessValueForKey:@"fromToken"];

	NSMutableSet<TokenModelObject*> *result = (NSMutableSet<TokenModelObject*>*)[self mutableSetValueForKey:@"fromToken"];

	[self didAccessValueForKey:@"fromToken"];
	return result;
}

@end

@implementation FiatPriceModelObjectAttributes 
+ (NSString *)usdPrice {
	return @"usdPrice";
}
@end

@implementation FiatPriceModelObjectRelationships 
+ (NSString *)fromToken {
	return @"fromToken";
}
@end

