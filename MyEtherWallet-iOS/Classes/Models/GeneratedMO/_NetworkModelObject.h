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
@class MasterTokenModelObject;
@class TokenModelObject;

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

@property (nonatomic, strong, nullable) AccountModelObject *fromAccount;

@property (nonatomic, strong) MasterTokenModelObject *master;

@property (nonatomic, strong, nullable) NSSet<TokenModelObject*> *tokens;
- (nullable NSMutableSet<TokenModelObject*>*)tokensSet;

@end

@interface _NetworkModelObject (TokensCoreDataGeneratedAccessors)
- (void)addTokens:(NSSet<TokenModelObject*>*)value_;
- (void)removeTokens:(NSSet<TokenModelObject*>*)value_;
- (void)addTokensObject:(TokenModelObject*)value_;
- (void)removeTokensObject:(TokenModelObject*)value_;

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

- (AccountModelObject*)primitiveFromAccount;
- (void)setPrimitiveFromAccount:(AccountModelObject*)value;

- (MasterTokenModelObject*)primitiveMaster;
- (void)setPrimitiveMaster:(MasterTokenModelObject*)value;

- (NSMutableSet<TokenModelObject*>*)primitiveTokens;
- (void)setPrimitiveTokens:(NSMutableSet<TokenModelObject*>*)value;

@end

@interface NetworkModelObjectAttributes: NSObject 
+ (NSString *)active;
+ (NSString *)chainID;
@end

@interface NetworkModelObjectRelationships: NSObject
+ (NSString *)fromAccount;
+ (NSString *)master;
+ (NSString *)tokens;
@end

NS_ASSUME_NONNULL_END
