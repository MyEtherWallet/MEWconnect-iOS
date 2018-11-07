//
//  ModuleFactoriesAssembly.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 14/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import ViperMcFlurryX;

#import "ModuleFactoriesAssembly.h"
#import "StoryboardsAssembly.h"

static NSString *const kHomeViewControllerIdentifier            = @"HomeViewController";
static NSString *const kTransactionViewControllerIdentifier     = @"TransactionViewController";
static NSString *const kMessageSignerViewControllerIdentifier   = @"MessageSignerViewController";
static NSString *const kSplashPasswordViewControllerIdentifier  = @"SplashPasswordViewController";

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

- (RamblerViperModuleFactory *) transactionFactory {
  return [TyphoonDefinition withClass:[RamblerViperModuleFactory class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition useInitializer:@selector(initWithStoryboard:andRestorationId:)
                                          parameters:^(TyphoonMethod *initializer) {
                                            [initializer injectParameterWith:[self.storyboardsAssembly confirmationStoryboard]];
                                            [initializer injectParameterWith:kTransactionViewControllerIdentifier];
                                          }];
                        }];
}

- (RamblerViperModuleFactory *) messageSignerFactory {
  return [TyphoonDefinition withClass:[RamblerViperModuleFactory class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition useInitializer:@selector(initWithStoryboard:andRestorationId:)
                                          parameters:^(TyphoonMethod *initializer) {
                                            [initializer injectParameterWith:[self.storyboardsAssembly confirmationStoryboard]];
                                            [initializer injectParameterWith:kMessageSignerViewControllerIdentifier];
                                          }];
                        }];
}

- (RamblerViperModuleFactory *) splashPasswordFactory {
  return [TyphoonDefinition withClass:[RamblerViperModuleFactory class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition useInitializer:@selector(initWithStoryboard:andRestorationId:)
                                          parameters:^(TyphoonMethod *initializer) {
                                            [initializer injectParameterWith:[self.storyboardsAssembly splashPasswordStoryboard]];
                                            [initializer injectParameterWith:kSplashPasswordViewControllerIdentifier];
                                          }];
                        }];
}

@end
