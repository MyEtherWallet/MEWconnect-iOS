//
//  ModuleFactoriesAssembly.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 14/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import ViperMcFlurry;

#import "ModuleFactoriesAssembly.h"
#import "StoryboardsAssembly.h"

static NSString *const kHomeViewControllerIdentifier = @"HomeViewController";

@implementation ModuleFactoriesAssembly

- (RamblerViperModuleFactory *) homeFactory {
  return [TyphoonDefinition withClass:[RamblerViperModuleFactory class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition useInitializer:@selector(initWithStoryboard:andRestorationId:)
                                          parameters:^(TyphoonMethod *initializer) {
                                            [initializer injectParameterWith:[self.storyboardsAssembly walletStoryboard]];
                                            [initializer injectParameterWith:kHomeViewControllerIdentifier];
                                          }];
                        }];
}

@end
