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

#import "ServiceComponents.h"

@protocol ResponseMappersFactory;
@class OperationFactoriesAssembly;
@class SystemInfrastructureAssembly;
@class PonsomizerAssembly;

@interface ServiceComponentsAssembly : TyphoonAssembly <ServiceComponents, RamblerInitialAssembly>
@property (nonatomic, strong, readonly) TyphoonAssembly <ResponseMappersFactory> *responseMappersFactory;
@property (nonatomic, strong, readonly) OperationFactoriesAssembly *operationFactoriesAssembly;
@property (nonatomic, strong, readonly) SystemInfrastructureAssembly *systemInfrastructureAssembly;
@property (nonatomic, strong, readonly) PonsomizerAssembly *ponsomizerAssembly;
@end
