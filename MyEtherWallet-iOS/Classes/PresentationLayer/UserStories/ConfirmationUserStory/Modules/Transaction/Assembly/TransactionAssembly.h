//
//  TransactionAssembly.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "ModuleAssemblyBase.h"

@import RamblerTyphoonUtils.AssemblyCollector;

@class PonsomizerAssembly;

@interface TransactionAssembly : ModuleAssemblyBase <RamblerInitialAssembly>
@property (nonatomic, strong, readonly) PonsomizerAssembly *ponsomizerAssembly;
@end
