//
//  ContextPasswordAssembly.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 11/09/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "ModuleAssemblyBase.h"
@import RamblerTyphoonUtils.AssemblyCollector;

@class PonsomizerAssembly;

@interface ContextPasswordAssembly : ModuleAssemblyBase <RamblerInitialAssembly>
@property (nonatomic, strong) PonsomizerAssembly *ponsomizerAssembly;
@end
