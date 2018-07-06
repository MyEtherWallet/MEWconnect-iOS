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

@class AccountModelObject;

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

@property (nonatomic, strong, nullable) NSString* transactionId;

@property (nonatomic, strong, nullable) AccountModelObject *fromAccount;

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

- (nullable NSString*)primitiveTransactionId;
- (void)setPrimitiveTransactionId:(nullable NSString*)value;

- (AccountModelObject*)primitiveFromAccount;
- (void)setPrimitiveFromAccount:(AccountModelObject*)value;

@end

@interface PurchaseHistoryModelObjectAttributes: NSObject 
+ (NSString *)amount;
+ (NSString *)date;
+ (NSString *)loaded;
+ (NSString *)transactionId;
@end

@interface PurchaseHistoryModelObjectRelationships: NSObject
+ (NSString *)fromAccount;
@end

NS_ASSUME_NONNULL_END
