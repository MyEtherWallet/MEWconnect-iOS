//
//  ModuleFactoriesAssembly.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 14/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Typhoon;
@import RamblerTyphoonUtils.AssemblyCollector;

@class RamblerViperModuleFactory;
@class StoryboardsAssembly;

@interface ModuleFactoriesAssembly : TyphoonAssembly <RamblerInitialAssembly>
@property (nonatomic, strong, readonly) StoryboardsAssembly *storyboardsAssembly;
- (RamblerViperModuleFactory *) homeFactory;
- (RamblerViperModuleFactory *) transactionFactory;
- (RamblerViperModuleFactory *) messageSignerFactory;
- (RamblerViperModuleFactory *) splashPasswordFactory;
@end
