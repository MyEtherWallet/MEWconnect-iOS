//
//  SplashPasswordAssembly.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 26/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "ModuleAssemblyBase.h"
@import RamblerTyphoonUtils.AssemblyCollector;

@class PonsomizerAssembly;

@interface SplashPasswordAssembly : ModuleAssemblyBase <RamblerInitialAssembly>
@property (nonatomic, strong) PonsomizerAssembly *ponsomizerAssembly;
@end
