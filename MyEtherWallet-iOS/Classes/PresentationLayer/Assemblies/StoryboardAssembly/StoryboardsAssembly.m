//
//  StoryboardsAssembly.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 15/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "StoryboardsAssembly.h"

#import "SystemInfrastructureAssembly.h"

static NSString *const kMainStoryboardName            = @"Main";
static NSString *const kSplashPasswordStoryboardName  = @"SplashPassword";
static NSString *const kWalletStoryboardName          = @"Wallet";
static NSString *const kLaunchStoryboardName          = @"LaunchScreen";
static NSString *const kConfirmationStoryboardName    = @"Confirmation";

@implementation StoryboardsAssembly

- (UIStoryboard *) mainStoryboard {
  return [TyphoonDefinition withClass:[TyphoonStoryboard class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition useInitializer:@selector(storyboardWithName:factory:bundle:)
                                          parameters:^(TyphoonMethod *initializer) {
                                            [initializer injectParameterWith:kMainStoryboardName];
                                            [initializer injectParameterWith:self];
                                            [initializer injectParameterWith:[self.systemInfrastructureAssembly mainBundle]];
                                          }];
                        }];
}

- (UIStoryboard *) splashPasswordStoryboard {
  return [TyphoonDefinition withClass:[TyphoonStoryboard class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition useInitializer:@selector(storyboardWithName:factory:bundle:)
                                          parameters:^(TyphoonMethod *initializer) {
                                            [initializer injectParameterWith:kSplashPasswordStoryboardName];
                                            [initializer injectParameterWith:self];
                                            [initializer injectParameterWith:[self.systemInfrastructureAssembly mainBundle]];
                                          }];
                        }];
}

- (UIStoryboard *) walletStoryboard {
  return [TyphoonDefinition withClass:[TyphoonStoryboard class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition useInitializer:@selector(storyboardWithName:factory:bundle:)
                                          parameters:^(TyphoonMethod *initializer) {
                                            [initializer injectParameterWith:kWalletStoryboardName];
                                            [initializer injectParameterWith:self];
                                            [initializer injectParameterWith:[self.systemInfrastructureAssembly mainBundle]];
                                          }];
                        }];
}

- (UIStoryboard *) launchStoryboard {
  return [TyphoonDefinition withClass:[TyphoonStoryboard class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition useInitializer:@selector(storyboardWithName:factory:bundle:)
                                          parameters:^(TyphoonMethod *initializer) {
                                            [initializer injectParameterWith:kLaunchStoryboardName];
                                            [initializer injectParameterWith:self];
                                            [initializer injectParameterWith:[self.systemInfrastructureAssembly mainBundle]];
                                          }];
                        }];
}

- (UIStoryboard *) confirmationStoryboard {
  return [TyphoonDefinition withClass:[TyphoonStoryboard class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition useInitializer:@selector(storyboardWithName:factory:bundle:)
                                          parameters:^(TyphoonMethod *initializer) {
                                            [initializer injectParameterWith:kConfirmationStoryboardName];
                                            [initializer injectParameterWith:self];
                                            [initializer injectParameterWith:[self.systemInfrastructureAssembly mainBundle]];
                                          }];
                        }];
}

@end
