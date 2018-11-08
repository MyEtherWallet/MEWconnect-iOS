//
//  ValidatorComponentsAssembly.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 08/11/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;
@import RamblerTyphoonUtils.AssemblyCollector;
@import Typhoon;

@protocol ServiceComponents;

#import "ValidatorComponents.h"

NS_ASSUME_NONNULL_BEGIN

@interface ValidatorComponentsAssembly : TyphoonAssembly <ValidatorComponents, RamblerInitialAssembly>
@property (nonatomic, strong, readonly) TyphoonAssembly <ServiceComponents> *serviceComponents;
@end

NS_ASSUME_NONNULL_END

#import "ServiceComponents.h"
