// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to AccountModelObject.h instead.

#if __has_feature(modules)
    @import Foundation;
    @import CoreData;
#else
    #import <Foundation/Foundation.h>
    #import <CoreData/CoreData.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@class NetworkModelObject;
@class FiatPriceModelObject;
@class TokenModelObject;

@interface AccountModelObjectID : NSManagedObjectID {}
@end

@interface _AccountModelObject : NSManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (nullable NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) AccountModelObjectID *objectID;

@property (nonatomic, strong, nullable) NSNumber* active;

@property (atomic) BOOL activeValue;
- (BOOL)activeValue;
- (void)setActiveValue:(BOOL)value_;

@property (nonatomic, strong, nullable) NSNumber* backedUp;

@property (atomic) BOOL backedUpValue;
- (BOOL)backedUpValue;
- (void)setBackedUpValue:(BOOL)value_;

@property (nonatomic, strong, nullable) NSDecimalNumber* balance;

@property (nonatomic, strong, nullable) NSNumber* decimals;

@property (atomic) int16_t decimalsValue;
- (int16_t)decimalsValue;
- (void)setDecimalsValue:(int16_t)value_;

@property (nonatomic, strong, nullable) NSString* publicAddress;

@property (nonatomic, strong, nullable) NetworkModelObject *fromNetwork;

@property (nonatomic, strong, nullable) FiatPriceModelObject *price;

@property (nonatomic, strong, nullable) NSSet<TokenModelObject*> *tokens;
- (nullable NSMutableSet<TokenModelObject*>*)tokensSet;

@end

@interface _AccountModelObject (TokensCoreDataGeneratedAccessors)
- (void)addTokens:(NSSet<TokenModelObject*>*)value_;
- (void)removeTokens:(NSSet<TokenModelObject*>*)value_;
- (void)addTokensObject:(TokenModelObject*)value_;
- (void)removeTokensObject:(TokenModelObject*)value_;

@end

@interface _AccountModelObject (CoreDataGeneratedPrimitiveAccessors)

- (nullable NSNumber*)primitiveActive;
- (void)setPrimitiveActive:(nullable NSNumber*)value;

- (BOOL)primitiveActiveValue;
- (void)setPrimitiveActiveValue:(BOOL)value_;

- (nullable NSNumber*)primitiveBackedUp;
- (void)setPrimitiveBackedUp:(nullable NSNumber*)value;

- (BOOL)primitiveBackedUpValue;
- (void)setPrimitiveBackedUpValue:(BOOL)value_;

- (nullable NSDecimalNumber*)primitiveBalance;
- (void)setPrimitiveBalance:(nullable NSDecimalNumber*)value;

- (nullable NSNumber*)primitiveDecimals;
- (void)setPrimitiveDecimals:(nullable NSNumber*)value;

- (int16_t)primitiveDecimalsValue;
- (void)setPrimitiveDecimalsValue:(int16_t)value_;

- (nullable NSString*)primitivePublicAddress;
- (void)setPrimitivePublicAddress:(nullable NSString*)value;

- (NetworkModelObject*)primitiveFromNetwork;
- (void)setPrimitiveFromNetwork:(NetworkModelObject*)value;

- (FiatPriceModelObject*)primitivePrice;
- (void)setPrimitivePrice:(FiatPriceModelObject*)value;

- (NSMutableSet<TokenModelObject*>*)primitiveTokens;
- (void)setPrimitiveTokens:(NSMutableSet<TokenModelObject*>*)value;

@end

@interface AccountModelObjectAttributes: NSObject 
+ (NSString *)active;
+ (NSString *)backedUp;
+ (NSString *)balance;
+ (NSString *)decimals;
+ (NSString *)publicAddress;
@end

@interface AccountModelObjectRelationships: NSObject
+ (NSString *)fromNetwork;
+ (NSString *)price;
+ (NSString *)tokens;
@end

NS_ASSUME_NONNULL_END
