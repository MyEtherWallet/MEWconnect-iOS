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
#import "StoryboardsAssembly.h"
#import "PonsomizerAssembly.h"
#import "ModuleFactoriesAssembly.h"

#import "ServiceComponents.h"

#import "CleanLaunchAppDelegate.h"
#import "SecurityAppDelegate.h"

#import "CleanLaunchRouter.h"
#import "SecurityRouter.h"

#import "ApplicationConfiguratorImplementation.h"
#import "ThirdPartiesConfiguratorImplementation.h"
#import "CoreDataConfiguratorImplementation.h"
#import "CrashCatcherConfiguratorImplementation.h"

#import "ApplicationAssembly.h"

@implementation ApplicationAssembly

- (RamblerAppDelegateProxy *)applicationDelegateProxy {
  return [TyphoonDefinition withClass:[RamblerAppDelegateProxy class]
                        configuration:^(TyphoonDefinition *definition){
                          [definition injectMethod:@selector(addAppDelegates:)
                                        parameters:^(TyphoonMethod *method) {
                                          [method injectParameterWith:@[[self cleanStartAppDelegate],
                                                                        [self securityAppDelegate]]];
                                        }];
                          definition.scope = TyphoonScopeSingleton;
                        }];
}

#pragma mark - AppDelegates

- (CleanLaunchAppDelegate *) cleanStartAppDelegate {
  return [TyphoonDefinition withClass:[CleanLaunchAppDelegate class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(applicationConfigurator)
                                                with:[self applicationConfigurator]];
                          [definition injectProperty:@selector(thirdPartiesConfigurator)
                                                with:[self thirdPartiesConfigurator]];
                          [definition injectProperty:@selector(cleanStartRouter)
                                                with:[self cleanStartRouter]];
                          [definition injectProperty:@selector(migrationService)
                                                with:[self.serviceComponents migrationService]];
                          [definition injectProperty:@selector(coreDataConfigurator)
                                                with:[self coreDataConfigurator]];
                          [definition injectProperty:@selector(crashCatcherConfigurator)
                                                with:[self crashCatcherConfigurator]];
                          definition.scope = TyphoonScopeSingleton;
                        }];
}

- (SecurityAppDelegate *) securityAppDelegate {
  return [TyphoonDefinition withClass:[SecurityAppDelegate class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(securityRouter)
                                                with:[self securityRouter]];
                          [definition injectProperty:@selector(securityService)
                                                with:[self.serviceComponents securityService]];
                        }];
}

#pragma mark - Configurators

- (id <ApplicationConfigurator>) applicationConfigurator {
  return [TyphoonDefinition withClass:[ApplicationConfiguratorImplementation class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(keychainService)
                                                with:[self.serviceComponents keychainService]];
                        }];
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
                          [definition injectProperty:@selector(ponsomizer)
                                                with:[self.ponsomizerAssembly ponsomizer]];
                        }];
}

- (id <CrashCatcherConfigurator>) crashCatcherConfigurator {
  return [TyphoonDefinition withClass:[CrashCatcherConfiguratorImplementation class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(rateService)
                                                with:[self.serviceComponents rateService]];
                        }];
}

#pragma mark - StartUpSystem

- (CleanLaunchRouter *) cleanStartRouter {
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
                          [definition injectProperty:@selector(splashPasswordFactory)
                                                with:[self.moduleFactoriesAssembly splashPasswordFactory]];
                          [definition injectProperty:@selector(launchStoryboard)
                                                with:[self.storyboardAssembly launchStoryboard]];
                          [definition injectProperty:@selector(propertyAnimatorsFactory)
                                                with:self.propertyAnimatorsFactory];
                        }];
}

- (SecurityRouter *) securityRouter {
  return [TyphoonDefinition withClass:[SecurityRouter class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition useInitializer:@selector(initWithWindow:)
                                          parameters:^(TyphoonMethod *initializer) {
                                            [initializer injectParameterWith:[self.systemInfrastructureAssembly mainWindow]];
                                          }];
                          [definition injectProperty:@selector(securityService)
                                                with:[self.serviceComponents securityService]];
                          [definition injectProperty:@selector(accountsService)
                                                with:[self.serviceComponents accountsService]];
                          [definition injectProperty:@selector(ponsomizer)
                                                with:[self.ponsomizerAssembly ponsomizer]];
                          [definition injectProperty:@selector(splashPasswordFactory)
                                                with:[self.moduleFactoriesAssembly splashPasswordFactory]];
                        }];
}

@end
