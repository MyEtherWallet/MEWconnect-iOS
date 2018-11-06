// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to FiatPriceModelObject.h instead.

#if __has_feature(modules)
    @import Foundation;
    @import CoreData;
#else
    #import <Foundation/Foundation.h>
    #import <CoreData/CoreData.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@class TokenModelObject;

@interface FiatPriceModelObjectID : NSManagedObjectID {}
@end

@interface _FiatPriceModelObject : NSManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (nullable NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) FiatPriceModelObjectID *objectID;

@property (nonatomic, strong, nullable) NSDecimalNumber* usdPrice;

@property (nonatomic, strong, nullable) NSSet<TokenModelObject*> *fromToken;
- (nullable NSMutableSet<TokenModelObject*>*)fromTokenSet;

@end

@interface _FiatPriceModelObject (FromTokenCoreDataGeneratedAccessors)
- (void)addFromToken:(NSSet<TokenModelObject*>*)value_;
- (void)removeFromToken:(NSSet<TokenModelObject*>*)value_;
- (void)addFromTokenObject:(TokenModelObject*)value_;
- (void)removeFromTokenObject:(TokenModelObject*)value_;

@end

@interface _FiatPriceModelObject (CoreDataGeneratedPrimitiveAccessors)

- (nullable NSDecimalNumber*)primitiveUsdPrice;
- (void)setPrimitiveUsdPrice:(nullable NSDecimalNumber*)value;

- (NSMutableSet<TokenModelObject*>*)primitiveFromToken;
- (void)setPrimitiveFromToken:(NSMutableSet<TokenModelObject*>*)value;

@end

@interface FiatPriceModelObjectAttributes: NSObject 
+ (NSString *)usdPrice;
@end

@interface FiatPriceModelObjectRelationships: NSObject
+ (NSString *)fromToken;
@end

NS_ASSUME_NONNULL_END
