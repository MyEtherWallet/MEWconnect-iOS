//
//  SimplexServiceImplementation.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 03/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "SimplexService.h"

@class SimplexOperationFactory;
@protocol OperationScheduler;
@protocol KeychainService;

@interface SimplexServiceImplementation : NSObject <SimplexService>
@property (nonatomic, strong) SimplexOperationFactory *simplexOperationFactory;
@property (nonatomic, strong) id <OperationScheduler> operationScheduler;
@property (nonatomic, strong) id <KeychainService> keychainService;
@end
