//
//  FiatPricesServiceImplementation.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 02/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "FiatPricesService.h"

@class FiatPricesOperationFactory;
@protocol OperationScheduler;

@interface FiatPricesServiceImplementation : NSObject <FiatPricesService>
@property (nonatomic, strong) FiatPricesOperationFactory *fiatPricesOperationFactory;
@property (nonatomic, strong) id <OperationScheduler> operationScheduler;
@end
