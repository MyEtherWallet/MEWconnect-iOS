//
//  ApplicationHelperAssembly.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 15/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Typhoon;
@import RamblerTyphoonUtils.AssemblyCollector;

@protocol NavigationControllerFactory;
@class StoryboardsAssembly;

@interface ApplicationHelperAssembly : TyphoonAssembly <RamblerInitialAssembly>
@property (nonatomic, strong, readonly) StoryboardsAssembly *storyboardAssembly;
- (id<NavigationControllerFactory>)navigationControllerFactory;
@end
