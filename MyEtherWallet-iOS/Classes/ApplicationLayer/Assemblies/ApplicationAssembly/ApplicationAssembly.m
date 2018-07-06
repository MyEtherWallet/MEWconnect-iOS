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
#import "PonsomizerAssembly.h"

#import "ServiceComponents.h"

#import "CleanLaunchAppDelegate.h"
#import "CleanLaunchRouter.h"
#import "ApplicationConfiguratorImplementation.h"
#import "ThirdPartiesConfiguratorImplementation.h"
#import "CoreDataConfiguratorImplementation.h"

#import "ApplicationAssembly.h"

@implementation ApplicationAssembly

- (RamblerAppDelegateProxy *)applicationDelegateProxy {
  return [TyphoonDefinition withClass:[RamblerAppDelegateProxy class]
                        configuration:^(TyphoonDefinition *definition){
                          [definition injectMethod:@selector(addAppDelegates:)
                                        parameters:^(TyphoonMethod *method) {
                                          [method injectParameterWith:@[[self cleanStartAppDelegate]]
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
                          [definition injectProperty:@selector(coreDataConfigurator)
                                                with:[self coreDataConfigurator]];
                          
                          definition.scope = TyphoonScopeSingleton;
                        }];
}

- (id <ApplicationConfigurator>) applicationConfigurator {
  return [TyphoonDefinition withClass:[ApplicationConfiguratorImplementation class]];
}

- (id <ThirdPartiesConfigurator>) thirdPartiesConfigurator {
  return [TyphoonDefinition withClass:[ThirdPartiesConfiguratorImplementation class]];
}

- (id <CoreDataConfigurator>) coreDataConfigurator {
  return [TyphoonDefinition withClass:[CoreDataConfiguratorImplementation class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(fileManager)
                                                with:[self.systemInfrastructureAssembly fileManager]];
                          [definition injectProperty:@selector(keychainService)
                                                with:[self.serviceComponents keychainService]];
                        }];
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
                          [definition injectProperty:@selector(accountsService)
                                                with:[self.serviceComponents accountsService]];
                          [definition injectProperty:@selector(ponsomizer)
                                                with:[self.ponsomizerAssembly ponsomizer]];
                          [definition injectProperty:@selector(passwordStoryboard)
                                                with:[self.storyboardAssembly splashPasswordStoryboard]];
                        }];
}

@end
