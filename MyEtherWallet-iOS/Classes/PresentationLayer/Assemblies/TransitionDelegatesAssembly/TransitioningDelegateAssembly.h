//
//  TransitioningDelegateAssembly.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 26/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Typhoon;
@import RamblerTyphoonUtils.AssemblyCollector;

#import "TransitioningDelegateFactory.h"

@protocol PresentationControllerFactory;

@interface TransitioningDelegateAssembly : TyphoonAssembly <TransitioningDelegateFactory, RamblerInitialAssembly>
@property (nonatomic, strong, readonly) TyphoonAssembly <PresentationControllerFactory> *presentationControllerFactory;
@end
