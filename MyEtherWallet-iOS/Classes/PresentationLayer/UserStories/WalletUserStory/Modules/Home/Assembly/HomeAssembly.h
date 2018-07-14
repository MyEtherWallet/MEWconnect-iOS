//
//  HomeAssembly.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "ModuleAssemblyBase.h"

@import RamblerTyphoonUtils.AssemblyCollector;

@class FetchedResultsControllerAssembly;
@class PonsomizerAssembly;

@interface HomeAssembly : ModuleAssemblyBase <RamblerInitialAssembly>
@property (nonatomic, strong, readonly) FetchedResultsControllerAssembly *cacheTrackerAssembly;
@property (nonatomic, strong, readonly) PonsomizerAssembly *ponsomizerAssembly;
@end
