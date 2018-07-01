// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to NetworkModelObject.h instead.

#if __has_feature(modules)
    @import Foundation;
    @import CoreData;
#else
    #import <Foundation/Foundation.h>
    #import <CoreData/CoreData.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@class AccountModelObject;

@interface NetworkModelObjectID : NSManagedObjectID {}
@end

@interface _NetworkModelObject : NSManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (nullable NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) NetworkModelObjectID *objectID;

@property (nonatomic, strong, nullable) NSNumber* active;

@property (atomic) BOOL activeValue;
- (BOOL)activeValue;
- (void)setActiveValue:(BOOL)value_;

@property (nonatomic, strong, nullable) NSNumber* chainID;

@property (atomic) int16_t chainIDValue;
- (int16_t)chainIDValue;
- (void)setChainIDValue:(int16_t)value_;

@property (nonatomic, strong, nullable) NSOrderedSet<AccountModelObject*> *accounts;
- (nullable NSMutableOrderedSet<AccountModelObject*>*)accountsSet;

@end

@interface _NetworkModelObject (AccountsCoreDataGeneratedAccessors)
- (void)addAccounts:(NSOrderedSet<AccountModelObject*>*)value_;
- (void)removeAccounts:(NSOrderedSet<AccountModelObject*>*)value_;
- (void)addAccountsObject:(AccountModelObject*)value_;
- (void)removeAccountsObject:(AccountModelObject*)value_;

- (void)insertObject:(AccountModelObject*)value inAccountsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromAccountsAtIndex:(NSUInteger)idx;
- (void)insertAccounts:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeAccountsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInAccountsAtIndex:(NSUInteger)idx withObject:(AccountModelObject*)value;
- (void)replaceAccountsAtIndexes:(NSIndexSet *)indexes withAccounts:(NSArray *)values;

@end

@interface _NetworkModelObject (CoreDataGeneratedPrimitiveAccessors)

- (nullable NSNumber*)primitiveActive;
- (void)setPrimitiveActive:(nullable NSNumber*)value;

- (BOOL)primitiveActiveValue;
- (void)setPrimitiveActiveValue:(BOOL)value_;

- (nullable NSNumber*)primitiveChainID;
- (void)setPrimitiveChainID:(nullable NSNumber*)value;

- (int16_t)primitiveChainIDValue;
- (void)setPrimitiveChainIDValue:(int16_t)value_;

- (NSMutableOrderedSet<AccountModelObject*>*)primitiveAccounts;
- (void)setPrimitiveAccounts:(NSMutableOrderedSet<AccountModelObject*>*)value;

@end

@interface NetworkModelObjectAttributes: NSObject 
+ (NSString *)active;
+ (NSString *)chainID;
@end

@interface NetworkModelObjectRelationships: NSObject
+ (NSString *)accounts;
@end

NS_ASSUME_NONNULL_END
