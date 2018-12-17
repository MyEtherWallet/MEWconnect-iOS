//
//  PonsomizerImplementation.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 22/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import <objc/runtime.h>
@import CoreData;

#import "PonsomizerImplementation.h"

static NSString *const PONSOPostfix = @"PlainObject";
static NSString *const PONSOSuperClassPrefix = @"_";
static NSString *const NSMOPostfix = @"ModelObject";

@implementation PonsomizerImplementation

#pragma mark - Методы протокола <Ponsomizer>

- (id)convertObject:(id)object {
  return [self convertObject:object
          ignoringProperties:@[]];
}

#pragma mark - Вспомогательные методы

- (id)convertObject:(id)object
 ignoringProperties:(NSArray<NSString *> *)ignoredProperties {
  if ([object isKindOfClass:[NSArray class]]) {
    return [self convertCollection:object
          ignoringObjectProperties:ignoredProperties
                mutableResultClass:[NSMutableArray class]];
  } else if ([object isKindOfClass:[NSSet class]]) {
    return [self convertCollection:object
          ignoringObjectProperties:ignoredProperties
                mutableResultClass:[NSMutableSet class]];
  } else if ([object isKindOfClass:[NSOrderedSet class]]) {
    return [self convertCollection:object
          ignoringObjectProperties:ignoredProperties
                mutableResultClass:[NSMutableOrderedSet class]];
  } else if ([object isKindOfClass:[NSManagedObject class]]) {
    return [self convertManagedObject:object
                   ignoringProperties:ignoredProperties];
  } else {
    return object;
  }
}

- (id)convertCollection:(id<NSFastEnumeration>)collection
ignoringObjectProperties:(NSArray<NSString *> *)ignoredProperties
     mutableResultClass:(Class)mutableResultClass {
  id result = [mutableResultClass new];
  for (id object in collection) {
    id ponsoInstance = [self convertObject:object
                        ignoringProperties:ignoredProperties];
    [result addObject:ponsoInstance];
  }
  return [result copy];
}

- (id)convertManagedObject:(NSManagedObject *)object
        ignoringProperties:(NSArray<NSString *> *)ignoredProperties {
  
  id ponsoInstance = nil;
  
  Class class = [object class];
  
  do {
    NSString *modelObjectName = [NSStringFromClass(class) stringByReplacingOccurrencesOfString:NSMOPostfix
                                                                                             withString:@""];
    NSString *ponsoClassName = [modelObjectName stringByAppendingString:PONSOPostfix];
    NSString *ponsoSuperclassName = [PONSOSuperClassPrefix stringByAppendingString:ponsoClassName];
    
    const char *ponsoClassNameOldCString = [ponsoClassName UTF8String];
    const char *ponsoSuperClassNameOldCString = [ponsoSuperclassName UTF8String];
    
    Class ponsoClass = objc_getClass(ponsoClassNameOldCString);
    Class ponsoSuperclass = objc_getClass(ponsoSuperClassNameOldCString);
    
    NSAssert(ponsoClass != nil, @"Can't find class %@", ponsoClassName);
    NSAssert(ponsoSuperclass != nil, @"Can't find superclass %@", ponsoSuperclassName);
    
    NSMutableArray<NSString *> *nextEntityIgnoredProperties = [ignoredProperties mutableCopy];
    NSArray<NSString *> *currentObjectIgnoringProperties = [self ignoringPropertiesOfObject:object
                                                                                 ponsoClass:ponsoSuperclass];
    [nextEntityIgnoredProperties addObjectsFromArray:currentObjectIgnoringProperties];
    
    if (!ponsoInstance) {
      ponsoInstance = [ponsoClass new];
    }
    
    unsigned int propertiesCount = 0u;
    objc_property_t *properties = class_copyPropertyList(ponsoSuperclass, &propertiesCount);
    
    for (unsigned int propertyIndex = 0u; propertyIndex < propertiesCount; ++propertyIndex) {
      objc_property_t property = properties[propertyIndex];
      const char *name = property_getName(property);
      
      SEL selector = (SEL)name;
      NSString *selectorAsString = NSStringFromSelector(selector);
      
      if ([ignoredProperties containsObject:selectorAsString]) {
        continue;
      }
      
      if ([object respondsToSelector:selector]) {
        id value = [object valueForKey:selectorAsString];
        
        id ponsoValue = [self convertObject:value
                         ignoringProperties:[nextEntityIgnoredProperties copy]];
        [ponsoInstance setValue:ponsoValue
                         forKey:selectorAsString];
      }
    }
    
    free(properties);
    
    class = class_getSuperclass(class_getSuperclass(class));
  } while (![NSStringFromClass(class) isEqualToString:NSStringFromClass([NSManagedObject class])]);
  
  return ponsoInstance;
}

- (NSMutableArray<NSString *> *)ignoringPropertiesOfObject:(NSManagedObject *)object
                                                ponsoClass:(Class)ponsoClass {
  NSMutableArray<NSString *> *ignoredProperties = [NSMutableArray array];
  
  unsigned int propertiesCount = 0u;
  objc_property_t *properties = class_copyPropertyList(ponsoClass, &propertiesCount);
  
  for (unsigned int propertyIndex = 0u; propertyIndex < propertiesCount; ++propertyIndex) {
    objc_property_t property = properties[propertyIndex];
    const char *name = property_getName(property);
    SEL selector = (SEL)name;
    NSString *selectorAsString = NSStringFromSelector(selector);
    
    if ([object respondsToSelector:selector]
        && [object isKindOfClass:[NSManagedObject class]]) {
      
      NSString *ignoredRelationship = [self inverseNameForRelationship:selectorAsString
                                                      forManagedObject:object];
      if (ignoredRelationship != nil) {
        [ignoredProperties addObject:ignoredRelationship];
      }
    }
  }
  
  return ignoredProperties;
}

- (nullable NSString *)inverseNameForRelationship:(NSString *)relationshipName
                                 forManagedObject:(NSManagedObject *)managedObject {
  
  NSString *result = nil;
  NSRelationshipDescription *relationshipDescription = [managedObject.entity relationshipsByName][relationshipName];
  if (relationshipDescription != nil) {
    result = relationshipDescription.inverseRelationship.name;
  }
  return result;
}

@end
