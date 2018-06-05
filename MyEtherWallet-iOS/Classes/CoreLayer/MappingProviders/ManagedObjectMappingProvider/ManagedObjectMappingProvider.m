//
//  ManagedObjectMappingProvider.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 22/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import MagicalRecord;
@import EasyMapping;

#import "ManagedObjectMappingProvider.h"

#import "EntityNameFormatter.h"

#import "NSString+RCFCapitalization.h"

#import "TokenModelObject.h"

@implementation ManagedObjectMappingProvider

- (EKManagedObjectMapping *)mappingForManagedObjectModelClass:(Class)managedObjectModelClass {
  NSString *managedObjectModelStringName = NSStringFromClass(managedObjectModelClass);
  NSString *mappingName = [NSString stringWithFormat:@"%@Mapping", managedObjectModelStringName];
  NSString *decapitalizedMappingName = [mappingName rcf_decapitalizedStringSavingCase];
  
  EKManagedObjectMapping *selectedMapping = nil;
  SEL mappingSelector = NSSelectorFromString(decapitalizedMappingName);
  if ([self respondsToSelector:mappingSelector]) {
    selectedMapping = ((EKManagedObjectMapping* (*)(id, SEL))[self methodForSelector:mappingSelector])(self, mappingSelector);
  }
  return selectedMapping;
}

#pragma mark - Mappings

- (EKManagedObjectMapping *) tokenModelObjectMapping {
  NSDictionary *properties = @{@"addr": NSStringFromSelector(@selector(address)),
                               @"balance": NSStringFromSelector(@selector(balance)),
                               @"decimals": NSStringFromSelector(@selector(decimals)),
                               @"name": NSStringFromSelector(@selector(name)),
                               @"symbol": NSStringFromSelector(@selector(symbol))};
  Class entityClass = [TokenModelObject class];
  NSString *entityName = [self.entityNameFormatter transformToEntityNameClass:entityClass];
  return [EKManagedObjectMapping mappingForEntityName:entityName
                                            withBlock:^(EKManagedObjectMapping * _Nonnull mapping) {
                                              mapping.primaryKey = NSStringFromSelector(@selector(name));
                                              [mapping mapPropertiesFromDictionary:properties];
                                            }];
}

//- (EKManagedObjectMapping *) tokenModelObjectMapping {
//  NSDictionary *properties = @{@"token": NSStringFromSelector(@selector(token))};
//  Class entityClass = [TokenModelObject class];
//  NSString *entityName = [self.entityNameFormatter transformToEntityNameClass:entityClass];
//  return [EKManagedObjectMapping mappingForEntityName:entityName
//                                            withBlock:^(EKManagedObjectMapping *mapping) {
//                                              [mapping mapPropertiesFromDictionary:properties];
//                                            }];
//}
//
//- (EKManagedObjectMapping *) profileModelObjectMapping {
//  NSDictionary *properties = @{@"firstName" : NSStringFromSelector(@selector(firstName)),
//                               @"lastName" : NSStringFromSelector(@selector(lastName)),
//                               @"email" : NSStringFromSelector(@selector(email)),
//                               @"phone" : NSStringFromSelector(@selector(phone)),
//                               @"avatar" : NSStringFromSelector(@selector(avatar)),
//                               @"unique_key" : NSStringFromSelector(@selector(uniqueKey)),
//                               @"card_number" : NSStringFromSelector(@selector(cardNumber)),
//                               @"balance" : NSStringFromSelector(@selector(balance)),
//                               @"level" : NSStringFromSelector(@selector(level)),
//                               @"discount" : NSStringFromSelector(@selector(discount)),
//                               @"points_to_up" : NSStringFromSelector(@selector(pointsToUp))
//                               };
//  Class entityClass = [ProfileModelObject class];
//  NSString *entityName = [self.entityNameFormatter transformToEntityNameClass:entityClass];
//  return [EKManagedObjectMapping mappingForEntityName:entityName
//                                            withBlock:^(EKManagedObjectMapping *mapping) {
//                                              mapping.primaryKey = NSStringFromSelector(@selector(uniqueKey));
//                                              [mapping mapPropertiesFromDictionary:properties];
//                                              [mapping mapKeyPath:@"birthDate"
//                                                       toProperty:NSStringFromSelector(@selector(birthDate))
//                                                   withValueBlock:[self birthDateValueBlock]];
//                                              [mapping mapKeyPath:@"city"
//                                                       toProperty:NSStringFromSelector(@selector(city))
//                                                   withValueBlock:[self cityValueBlock]];
//                                              [mapping mapKeyPath:@"sex"
//                                                       toProperty:NSStringFromSelector(@selector(sex))
//                                                   withValueBlock:[self sexValueBlock]];
//                                              [mapping mapKeyPath:@"receive"
//                                                       toProperty:NSStringFromSelector(@selector(notifications))
//                                                   withValueBlock:[self receiveNotificationValueBlock]];
//                                              [mapping hasMany:[AddressModelObject class]
//                                                    forKeyPath:@"addresses"
//                                                   forProperty:NSStringFromSelector(@selector(addresses))
//                                             withObjectMapping:[self addressModelObjectMapping]];
//                                            }];
//}
//
//- (EKManagedObjectMapping *) addressModelObjectMapping {
//  NSDictionary *properties = @{@"id" : NSStringFromSelector(@selector(id)),
//                               @"street" : NSStringFromSelector(@selector(street)),
//                               @"bldg" : NSStringFromSelector(@selector(building)),
//                               @"block" : NSStringFromSelector(@selector(block)),
//                               @"entry" : NSStringFromSelector(@selector(entry)),
//                               @"floor" : NSStringFromSelector(@selector(floor)),
//                               @"apt" : NSStringFromSelector(@selector(apartment)),
//                               @"code" : NSStringFromSelector(@selector(code)),
//                               @"comments" : NSStringFromSelector(@selector(comments))
//                               };
//  Class entityClass = [AddressModelObject class];
//  NSString *entityName = [self.entityNameFormatter transformToEntityNameClass:entityClass];
//  return [EKManagedObjectMapping mappingForEntityName:entityName
//                                            withBlock:^(EKManagedObjectMapping *mapping) {
//                                              mapping.primaryKey = NSStringFromSelector(@selector(id));
//                                              [mapping mapPropertiesFromDictionary:properties];
//                                              [mapping mapKeyPath:@"city"
//                                                       toProperty:NSStringFromSelector(@selector(city))
//                                                   withValueBlock:[self cityValueBlock]];
//                                            }];
//}
//
//- (EKManagedObjectMapping *) categoryModelObjectMapping {
//  NSDictionary *properties = @{@"id" : NSStringFromSelector(@selector(id)),
//                               @"name" : NSStringFromSelector(@selector(name)),
//                               @"order" : NSStringFromSelector(@selector(order))};
//  Class entityClass = [CategoryModelObject class];
//  NSString *entityName = [self.entityNameFormatter transformToEntityNameClass:entityClass];
//  EKManagedObjectMapping *mapping = [EKManagedObjectMapping mappingForEntityName:entityName
//                                                                       withBlock:^(EKManagedObjectMapping * _Nonnull mapping) {
//                                                                         mapping.primaryKey = NSStringFromSelector(@selector(id));
//                                                                         [mapping mapPropertiesFromDictionary:properties];
//                                                                         [mapping hasMany:[TagModelObject class]
//                                                                               forKeyPath:@"filters"
//                                                                              forProperty:NSStringFromSelector(@selector(tags))
//                                                                        withObjectMapping:[self tagModelObjectMapping]];
//                                                                       }];
//  [mapping hasMany:[CategoryModelObject class] forKeyPath:@"children" forProperty:NSStringFromSelector(@selector(childrens)) withObjectMapping:mapping];
//  return mapping;
//}
//
//- (EKManagedObjectMapping *) tagModelObjectMapping {
//  NSDictionary *properties = @{@"id" : NSStringFromSelector(@selector(id)),
//                               @"ingredient" : NSStringFromSelector(@selector(ingredient)),
//                               @"name" : NSStringFromSelector(@selector(name))};
//  Class entityClass = [TagModelObject class];
//  NSString *entityName = [self.entityNameFormatter transformToEntityNameClass:entityClass];
//  return [EKManagedObjectMapping mappingForEntityName:entityName
//                                            withBlock:^(EKManagedObjectMapping * _Nonnull mapping) {
//                                              mapping.primaryKey = NSStringFromSelector(@selector(id));
//                                              [mapping mapPropertiesFromDictionary:properties];
//                                            }];
//}
//
//- (EKManagedObjectMapping *) cityModelObjectMapping {
//  NSDictionary *properties = @{@"id" : NSStringFromSelector(@selector(id)),
//                               @"name" : NSStringFromSelector(@selector(name)),
//                               @"radius" : NSStringFromSelector(@selector(radius)),
//                               @"isHappyBox" : NSStringFromSelector(@selector(isHappyBox))
//                               //                               @"readyPickupTime" : NSStringFromSelector(@selector(pickupTime)),
//                               };
//  Class entityClass = [CityModelObject class];
//  NSString *entityName = [self.entityNameFormatter transformToEntityNameClass:entityClass];
//  return [EKManagedObjectMapping mappingForEntityName:entityName
//                                            withBlock:^(EKManagedObjectMapping *mapping) {
//                                              mapping.primaryKey = NSStringFromSelector(@selector(id));
//                                              [mapping mapPropertiesFromDictionary:properties];
//                                              [mapping mapKeyPath:@"readyPickupTime"
//                                                       toProperty:NSStringFromSelector(@selector(pickupTime))
//                                                   withValueBlock:[self pickupTimeValueBlock]];
//                                              [mapping hasOne:[CoordinateModelObject class]
//                                                   forKeyPath:@"coordinate"
//                                                  forProperty:NSStringFromSelector(@selector(coordinate))
//                                            withObjectMapping:[self coordinateModelObjectMapping]];
//                                              [mapping mapKeyPath:@"paymentMethods"
//                                                       toProperty:NSStringFromSelector(@selector(paymentMethods))
//                                                   withValueBlock:[self paymentValueBlock]];
//                                              [mapping hasOne:[DeliveryModelObject class]
//                                                   forKeyPath:@"delivery"
//                                                  forProperty:NSStringFromSelector(@selector(delivery))
//                                            withObjectMapping:[self deliveryModelObjectMapping]];
//                                              [mapping hasMany:[ServicePointModelObject class]
//                                                    forKeyPath:@"servicePoints"
//                                                   forProperty:NSStringFromSelector(@selector(servicePoints))
//                                             withObjectMapping:[self servicePointModelObjectMapping]];
//                                              [mapping hasMany:[HourModelObject class]
//                                                    forKeyPath:@"onlineSupportHours"
//                                                   forProperty:NSStringFromSelector(@selector(onlineSupportHours))
//                                             withObjectMapping:[self hourModelObjectMapping]];
//                                            }];
//}
//
//- (EKManagedObjectMapping *) deliveryModelObjectMapping {
//  NSDictionary *properties = @{@"deliveryPrice" : NSStringFromSelector(@selector(price)),
//                               @"freeDeliveryThreshold" : NSStringFromSelector(@selector(freeDeliveryPrice)),
//                               @"deliverySummary" : NSStringFromSelector(@selector(summary)),
//                               @"deliveryZonesMap" : NSStringFromSelector(@selector(zoneMap)),
//                               @"outOfZoneTime" : NSStringFromSelector(@selector(outOfZoneTime))
//                               };
//  Class entityClass = [DeliveryModelObject class];
//  NSString *entityName = [self.entityNameFormatter transformToEntityNameClass:entityClass];
//  return [EKManagedObjectMapping mappingForEntityName:entityName
//                                            withBlock:^(EKManagedObjectMapping *mapping) {
//                                              [mapping mapPropertiesFromDictionary:properties];
//                                              [mapping hasMany:[HourModelObject class]
//                                                    forKeyPath:@"openHours"
//                                                   forProperty:NSStringFromSelector(@selector(hours))
//                                             withObjectMapping:[self hourModelObjectMapping]];
//                                              [mapping hasMany:[DeliveryZoneModelObject class]
//                                                    forKeyPath:@"deliveryZones"
//                                                   forProperty:NSStringFromSelector(@selector(zones))
//                                             withObjectMapping:[self deliveryZoneModelObjectMapping]];
//                                            }];
//}
//
//- (EKManagedObjectMapping *) servicePointModelObjectMapping {
//  NSDictionary *properties = @{@"id" : NSStringFromSelector(@selector(id)),
//                               @"name" : NSStringFromSelector(@selector(name)),
//                               @"address" : NSStringFromSelector(@selector(address)),
//                               @"hasAsia" : NSStringFromSelector(@selector(asia)),
//                               @"hasPanasia" : NSStringFromSelector(@selector(panasia)),
//                               };
//  Class entityClass = [ServicePointModelObject class];
//  NSString *entityName = [self.entityNameFormatter transformToEntityNameClass:entityClass];
//  return [EKManagedObjectMapping mappingForEntityName:entityName
//                                            withBlock:^(EKManagedObjectMapping *mapping) {
//                                              mapping.primaryKey = NSStringFromSelector(@selector(id));
//                                              [mapping mapPropertiesFromDictionary:properties];
//                                              [mapping hasOne:[CoordinateModelObject class]
//                                                   forKeyPath:@"coordinate"
//                                                  forProperty:NSStringFromSelector(@selector(coordinate))
//                                            withObjectMapping:[self coordinateModelObjectMapping]];
//                                              [mapping hasMany:[HourModelObject class]
//                                                    forKeyPath:@"workHours"
//                                                   forProperty:NSStringFromSelector(@selector(workHours))
//                                             withObjectMapping:[self hourModelObjectMapping]];
//                                              [mapping hasMany:[HourModelObject class]
//                                                    forKeyPath:@"orderHours"
//                                                   forProperty:NSStringFromSelector(@selector(orderHours))
//                                             withObjectMapping:[self hourModelObjectMapping]];
//                                              [mapping mapKeyPath:@"paymentMethods"
//                                                       toProperty:NSStringFromSelector(@selector(paymentMethods))
//                                                   withValueBlock:[self paymentValueBlock]];
//                                            }];
//}
//
//- (EKManagedObjectMapping *) deliveryZoneModelObjectMapping {
//  NSDictionary *properties = @{@"time" : NSStringFromSelector(@selector(time)),
//                               @"id" : NSStringFromSelector(@selector(id)),
//                               @"hasPanasian" : NSStringFromSelector(@selector(panasia))};
//  Class entityClass = [DeliveryZoneModelObject class];
//  NSString *entityName = [self.entityNameFormatter transformToEntityNameClass:entityClass];
//  return [EKManagedObjectMapping mappingForEntityName:entityName
//                                            withBlock:^(EKManagedObjectMapping *mapping) {
//                                              mapping.primaryKey = NSStringFromSelector(@selector(id));
//                                              [mapping mapPropertiesFromDictionary:properties];
//                                              [mapping hasOne:[ContourModelObject class]
//                                                   forKeyPath:@"zone"
//                                                  forProperty:NSStringFromSelector(@selector(contour))
//                                            withObjectMapping:[self contourModelObjectMapping]];
//                                              [mapping mapKeyPath:@"color"
//                                                       toProperty:NSStringFromSelector(@selector(color))
//                                                   withValueBlock:[self colorValueBlock]];
//                                            }];
//}
//
//- (EKManagedObjectMapping *) contourModelObjectMapping {
//  NSDictionary *properties = @{@"contour" : NSStringFromSelector(@selector(contour))};
//  Class entityClass = [ContourModelObject class];
//  NSString *entityName = [self.entityNameFormatter transformToEntityNameClass:entityClass];
//  EKManagedObjectMapping *mapping = [EKManagedObjectMapping mappingForEntityName:entityName
//                                                                       withBlock:^(EKManagedObjectMapping *mapping) {
//                                                                         [mapping mapPropertiesFromDictionary:properties];
//                                                                         //                                                                         [mapping hasMany:[CoordinateModelObject class]
//                                                                         //                                                                               forKeyPath:@"contour"
//                                                                         //                                                                              forProperty:NSStringFromSelector(@selector(coordinates))
//                                                                         //                                                                        withObjectMapping:[self coordinateModelObjectMapping]];
//                                                                       }];
//  [mapping hasMany:[ContourModelObject class]
//        forKeyPath:@"subContours"
//       forProperty:NSStringFromSelector(@selector(subcontours))
// withObjectMapping:mapping];
//  return mapping;
//}
//
//- (EKManagedObjectMapping *) hourModelObjectMapping {
//  NSDictionary *properties = @{@"dayOfWeek" : NSStringFromSelector(@selector(dayOfweek))};
//  Class entityClass = [HourModelObject class];
//  NSString *entityName = [self.entityNameFormatter transformToEntityNameClass:entityClass];
//  return [EKManagedObjectMapping mappingForEntityName:entityName
//                                            withBlock:^(EKManagedObjectMapping *mapping) {
//                                              [mapping mapPropertiesFromDictionary:properties];
//                                              [mapping mapKeyPath:@"start"
//                                                       toProperty:NSStringFromSelector(@selector(start))
//                                                   withValueBlock:[self dateValueBlock]];
//                                              [mapping mapKeyPath:@"end"
//                                                       toProperty:NSStringFromSelector(@selector(end))
//                                                   withValueBlock:[self dateValueBlock]];
//                                            }];
//}
//
//- (EKManagedObjectMapping *) coordinateModelObjectMapping {
//  Class entityClass = [CoordinateModelObject class];
//  NSString *entityName = [self.entityNameFormatter transformToEntityNameClass:entityClass];
//  return [EKManagedObjectMapping mappingForEntityName:entityName
//                                            withBlock:^(EKManagedObjectMapping *mapping) {
//                                              [mapping mapKeyPath:@"@self"
//                                                       toProperty:NSStringFromSelector(@selector(coordinate))
//                                                   withValueBlock:[self coordinateValueBlock]];
//                                            }];
//}

#pragma mark - Value Blocks
//
//- (EKManagedMappingValueBlock) coordinateValueBlock {
//  return ^id(NSString *key, NSDictionary *value, NSManagedObjectContext *context) {
//    CLLocationDegrees latitude = [value[@"lat"] doubleValue];
//    CLLocationDegrees longitude = [value[@"lon"] doubleValue];
//    CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
//    return location;
//  };
//}
//
//- (EKManagedMappingValueBlock) paymentValueBlock {
//  return ^id(NSString *key, NSDictionary *value, NSManagedObjectContext *context) {
//    PaymentType type = PaymentUndefinedType;
//    if ([value[@"cash"] boolValue]) {
//      type |= PaymentCashType;
//    }
//    if ([value[@"cardOnSite"] boolValue]) {
//      type |= PaymentCardOnSiteType;
//    }
//    if ([value[@"cardOnDelivery"] boolValue]) {
//      type |= PaymentCardOnDeliveryType;
//    }
//    if ([value[@"online"] boolValue]) {
//      type |= PaymentOnlineType;
//    }
//    return @(type);
//  };
//}
//
//- (EKManagedMappingValueBlock) dateValueBlock {
//  return ^id(NSString *key, NSDictionary *value, NSManagedObjectContext *context) {
//    NSString *time = [NSString stringWithFormat:@"%@:%@", value[@"hour"], value[@"minute"]];
//    return [self.timeFormatter dateFromString:time];
//  };
//}
//
//- (EKManagedMappingValueBlock) colorValueBlock {
//  return ^id(NSString *key, NSString *value, NSManagedObjectContext *context) {
//    return [UIColor colorWithRGBString:value];
//  };
//}
//
//- (EKManagedMappingValueBlock) pickupTimeValueBlock {
//  return ^id(NSString *key, id value, NSManagedObjectContext *context) {
//    if ([value respondsToSelector:@selector(integerValue)]) {
//      return @([value integerValue]);
//    } else {
//      return @0;
//    }
//  };
//}
//
//- (EKManagedMappingValueBlock) birthDateValueBlock {
//  return ^id(NSString *key, id value, NSManagedObjectContext *context) {
//    return [[NSDate dateWithTimeIntervalSince1970:[value doubleValue]] dateByAddingTimeInterval:10800];
//  };
//}
//
//- (EKManagedMappingValueBlock) cityValueBlock {
//  return ^id(NSString *key, id value, NSManagedObjectContext *context) {
//    if ([value isKindOfClass:[NSString class]]) {
//      NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.id == %@", value];
//      CityModelObject *city = [CityModelObject MR_findFirstWithPredicate:predicate inContext:context];
//      return city;
//    }
//    return nil;
//  };
//}
//
//- (EKManagedMappingValueBlock) sexValueBlock {
//  return ^id(NSString *key, NSString *value, NSManagedObjectContext *context) {
//    if ([value isEqualToString:@"m"]) {
//      return @(SexMaleType);
//    } else if ([value isEqualToString:@"f"]) {
//      return @(SexFemaleType);
//    }
//    return @(SexUndefinedType);
//  };
//}
//
//- (EKManagedMappingValueBlock) receiveNotificationValueBlock {
//  return ^id(NSString *key, NSDictionary *value, NSManagedObjectContext *context) {
//    NotificationType type = NotificationUndefinedType;
//    if ([value[@"receive_email"] boolValue]) {
//      type |= NotificationEmailType;
//    }
//    if ([value[@"receive_push"] boolValue]) {
//      type |= NotificationPushType;
//    }
//    if ([value[@"receive_sms"] boolValue]) {
//      type |= NotificationSMSType;
//    }
//    if ([value[@"receive_viber"] boolValue]) {
//      type |= NotificationViberType;
//    }
//    return @(type);
//  };
//}

@end
