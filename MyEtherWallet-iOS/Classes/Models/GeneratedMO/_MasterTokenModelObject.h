// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MasterTokenModelObject.h instead.

#if __has_feature(modules)
    @import Foundation;
    @import CoreData;
#else
    #import <Foundation/Foundation.h>
    #import <CoreData/CoreData.h>
#endif

#import "TokenModelObject.h"

NS_ASSUME_NONNULL_BEGIN

@class NetworkModelObject;

@interface MasterTokenModelObjectID : TokenModelObjectID {}
@end

@interface _MasterTokenModelObject : TokenModelObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (nullable NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) MasterTokenModelObjectID *objectID;

@property (nonatomic, strong, nullable) NetworkModelObject *fromNetworkMaster;

@end

@interface _MasterTokenModelObject (CoreDataGeneratedPrimitiveAccessors)

- (NetworkModelObject*)primitiveFromNetworkMaster;
- (void)setPrimitiveFromNetworkMaster:(NetworkModelObject*)value;

@end

@interface MasterTokenModelObjectRelationships: NSObject
+ (NSString *)fromNetworkMaster;
@end

NS_ASSUME_NONNULL_END
