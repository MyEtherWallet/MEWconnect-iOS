// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to PurchaseHistoryModelObject.h instead.

#if __has_feature(modules)
    @import Foundation;
    @import CoreData;
#else
    #import <Foundation/Foundation.h>
    #import <CoreData/CoreData.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@class TokenModelObject;

@interface PurchaseHistoryModelObjectID : NSManagedObjectID {}
@end

@interface _PurchaseHistoryModelObject : NSManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (nullable NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) PurchaseHistoryModelObjectID *objectID;

@property (nonatomic, strong, nullable) NSDecimalNumber* amount;

@property (nonatomic, strong, nullable) NSDate* date;

@property (nonatomic, strong, nullable) NSNumber* loaded;

@property (atomic) BOOL loadedValue;
- (BOOL)loadedValue;
- (void)setLoadedValue:(BOOL)value_;

@property (nonatomic, strong, nullable) NSNumber* status;

@property (atomic) int16_t statusValue;
- (int16_t)statusValue;
- (void)setStatusValue:(int16_t)value_;

@property (nonatomic, strong, nullable) NSString* userId;

@property (nonatomic, strong, nullable) TokenModelObject *fromToken;

@end

@interface _PurchaseHistoryModelObject (CoreDataGeneratedPrimitiveAccessors)

- (nullable NSDecimalNumber*)primitiveAmount;
- (void)setPrimitiveAmount:(nullable NSDecimalNumber*)value;

- (nullable NSDate*)primitiveDate;
- (void)setPrimitiveDate:(nullable NSDate*)value;

- (nullable NSNumber*)primitiveLoaded;
- (void)setPrimitiveLoaded:(nullable NSNumber*)value;

- (BOOL)primitiveLoadedValue;
- (void)setPrimitiveLoadedValue:(BOOL)value_;

- (nullable NSNumber*)primitiveStatus;
- (void)setPrimitiveStatus:(nullable NSNumber*)value;

- (int16_t)primitiveStatusValue;
- (void)setPrimitiveStatusValue:(int16_t)value_;

- (nullable NSString*)primitiveUserId;
- (void)setPrimitiveUserId:(nullable NSString*)value;

- (TokenModelObject*)primitiveFromToken;
- (void)setPrimitiveFromToken:(TokenModelObject*)value;

@end

@interface PurchaseHistoryModelObjectAttributes: NSObject 
+ (NSString *)amount;
+ (NSString *)date;
+ (NSString *)loaded;
+ (NSString *)status;
+ (NSString *)userId;
@end

@interface PurchaseHistoryModelObjectRelationships: NSObject
+ (NSString *)fromToken;
@end

NS_ASSUME_NONNULL_END
