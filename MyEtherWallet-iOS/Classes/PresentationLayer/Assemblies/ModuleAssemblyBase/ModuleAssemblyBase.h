//
//  ModuleAssemblyBase.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 15/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Typhoon;

@protocol ServiceComponents;
@protocol ValidatorComponents;
@protocol TransitioningDelegateFactory;
@class PresentationLayerHelpersAssembly;

@interface ModuleAssemblyBase : TyphoonAssembly
@property (nonatomic, strong, readonly) TyphoonAssembly <ServiceComponents> *serviceComponents;
@property (nonatomic, strong, readonly) TyphoonAssembly <ValidatorComponents> *validatorComponents;
@property (nonatomic, strong, readonly) TyphoonAssembly <TransitioningDelegateFactory> *transitioningDelegateFactory;
@property (nonatomic, strong, readonly) PresentationLayerHelpersAssembly *presentationLayerHelpersAssembly;
@end
