//
//  ManagedObjectMappingProvider.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 22/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@class EKManagedObjectMapping;
@protocol EntityNameFormatter;

@interface ManagedObjectMappingProvider : NSObject
@property (nonatomic, strong) id<EntityNameFormatter> entityNameFormatter;
- (EKManagedObjectMapping *)mappingForManagedObjectModelClass:(Class)managedObjectModelClass;
@end

