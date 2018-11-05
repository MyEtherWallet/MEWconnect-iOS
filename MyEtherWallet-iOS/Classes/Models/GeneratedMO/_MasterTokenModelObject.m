// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MasterTokenModelObject.m instead.

#import "_MasterTokenModelObject.h"

@implementation MasterTokenModelObjectID
@end

@implementation _MasterTokenModelObject

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"MasterToken" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"MasterToken";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"MasterToken" inManagedObjectContext:moc_];
}

- (MasterTokenModelObjectID*)objectID {
	return (MasterTokenModelObjectID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic fromNetworkMaster;

@end

@implementation MasterTokenModelObjectRelationships 
+ (NSString *)fromNetworkMaster {
	return @"fromNetworkMaster";
}
@end

