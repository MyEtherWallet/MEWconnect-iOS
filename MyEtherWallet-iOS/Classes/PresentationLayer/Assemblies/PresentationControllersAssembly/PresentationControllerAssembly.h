//
//  PresentationControllerAssembly.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 26/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Typhoon;
@import RamblerTyphoonUtils.AssemblyCollector;

#import "PresentationControllerFactory.h"

@protocol ServiceComponents;
@class PonsomizerAssembly;

@interface PresentationControllerAssembly : TyphoonAssembly <PresentationControllerFactory, RamblerInitialAssembly>
@property (nonatomic, strong, readonly) TyphoonAssembly <ServiceComponents> *serviceComponents;
@property (nonatomic, strong, readonly) PonsomizerAssembly *ponsomizerAssembly;
@end
