//
//  ApplicationAssembly.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 15/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import RamblerAppDelegateProxy;

#import "ApplicationHelperAssembly.h"
#import "SystemInfrastructureAssembly.h"
#import "StoryboardAssembly.h"

#import "ServiceComponents.h"

#import "CleanLaunchAppDelegate.h"
#import "CleanLaunchRouter.h"
#import "ApplicationConfiguratorImplementation.h"
#import "ThirdPartiesConfiguratorImplementation.h"

#import "ApplicationAssembly.h"

@implementation ApplicationAssembly

- (RamblerAppDelegateProxy *)applicationDelegateProxy {
  return [TyphoonDefinition withClass:[RamblerAppDelegateProxy class]
                        configuration:^(TyphoonDefinition *definition){
                          [definition injectMethod:@selector(addAppDelegates:)
                                        parameters:^(TyphoonMethod *method) {
                                          [method injectParameterWith:@[
                                                                        [self cleanStartAppDelegate]
                                                                        ]
                                           ];
                                        }];
                          definition.scope = TyphoonScopeSingleton;
                        }];
}

- (CleanLaunchAppDelegate *)cleanStartAppDelegate {
  return [TyphoonDefinition withClass:[CleanLaunchAppDelegate class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(applicationConfigurator)
                                                with:[self applicationConfigurator]];
                          [definition injectProperty:@selector(thirdPartiesConfigurator)
                                                with:[self thirdPartiesConfigurator]];
                          [definition injectProperty:@selector(cleanStartRouter)
                                                with:[self cleanStartRouter]];
                          
                          definition.scope = TyphoonScopeSingleton;
                        }];
}

- (id <ApplicationConfigurator>)applicationConfigurator {
  return [TyphoonDefinition withClass:[ApplicationConfiguratorImplementation class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(fileManager)
                                                with:[self.systemInfrastructureAssembly fileManager]];
                        }];
}

- (id <ThirdPartiesConfigurator>)thirdPartiesConfigurator {
  return [TyphoonDefinition withClass:[ThirdPartiesConfiguratorImplementation class]];
}

#pragma mark - StartUpSystem

- (CleanLaunchRouter *)cleanStartRouter {
  return [TyphoonDefinition withClass:[CleanLaunchRouter class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition useInitializer:@selector(initWithNavigationControllerFactory:window:)
                                          parameters:^(TyphoonMethod *initializer) {
                                            [initializer injectParameterWith:[self.applicationHelperAssembly navigationControllerFactory]];
                                            [initializer injectParameterWith:[self.systemInfrastructureAssembly mainWindow]];
                                          }];
                          [definition injectProperty:@selector(cryptoService)
                                                with:[self.serviceComponents MEWCrypto]];
                          [definition injectProperty:@selector(passwordStoryboard)
                                                with:[self.storyboardAssembly splashPasswordStoryboard]];
                        }];
}

@end
