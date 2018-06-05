//
//  ApplicationAssembly.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 15/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Typhoon;
@import RamblerTyphoonUtils.AssemblyCollector;

#import "ModuleAssemblyBase.h"

@class ApplicationHelperAssembly;
@class SystemInfrastructureAssembly;
@class StoryboardAssembly;

@interface ApplicationAssembly : ModuleAssemblyBase <RamblerInitialAssembly>
@property (nonatomic, strong, readonly) ApplicationHelperAssembly *applicationHelperAssembly;
@property (nonatomic, strong, readonly) SystemInfrastructureAssembly *systemInfrastructureAssembly;
@property (nonatomic, strong, readonly) StoryboardAssembly *storyboardAssembly;
@end
