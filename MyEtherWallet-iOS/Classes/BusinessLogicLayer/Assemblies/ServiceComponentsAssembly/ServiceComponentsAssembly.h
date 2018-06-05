//
//  ServiceComponentsAssembly.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 15/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;
@import RamblerTyphoonUtils.AssemblyCollector;
@import Typhoon;

@protocol ResponseMappersFactory;
@class OperationFactoriesAssembly;

#import "ServiceComponents.h"

@interface ServiceComponentsAssembly : TyphoonAssembly <ServiceComponents, RamblerInitialAssembly>
@property (nonatomic, strong, readonly) TyphoonAssembly <ResponseMappersFactory> *responseMappersFactory;
@property (nonatomic, strong) OperationFactoriesAssembly *operationFactoriesAssembly;
@end
