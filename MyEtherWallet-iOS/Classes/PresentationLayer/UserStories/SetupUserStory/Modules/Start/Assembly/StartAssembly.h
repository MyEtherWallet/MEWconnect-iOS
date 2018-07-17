//
//  StartAssembly.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 14/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import RamblerTyphoonUtils.AssemblyCollector;

#import "ModuleAssemblyBase.h"

@class ModuleFactoriesAssembly;

@interface StartAssembly : ModuleAssemblyBase <RamblerInitialAssembly>
@property (nonatomic, strong, readonly) ModuleFactoriesAssembly *moduleFactoriesAssembly;
@end
