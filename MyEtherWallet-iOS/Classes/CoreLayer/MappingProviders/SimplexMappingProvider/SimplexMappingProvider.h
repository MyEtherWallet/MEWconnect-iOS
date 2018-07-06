//
//  SimplexMappingProvider.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 03/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@class EKObjectMapping;
@protocol EntityNameFormatter;

@interface SimplexMappingProvider : NSObject
@property (nonatomic, strong) id<EntityNameFormatter> entityNameFormatter;
- (EKObjectMapping *)mappingForModelClass:(Class)modelClass;
@end
