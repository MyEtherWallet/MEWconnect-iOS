//
//  SystemInfrastructureAssembly.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 15/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "SystemInfrastructureAssembly.h"
#import "ApplicationConstants.h"

@implementation SystemInfrastructureAssembly

- (NSUserDefaults *) userDefaults {
  return [TyphoonDefinition withClass:[NSUserDefaults class] configuration:^(TyphoonDefinition *definition) {
    [definition useInitializer:@selector(initWithSuiteName:)
                    parameters:^(TyphoonMethod *initializer) {
                      [initializer injectParameterWith:kAppGroupIdentifier];
                    }];
    definition.scope = TyphoonScopeSingleton;
  }];
}

- (NSHTTPCookieStorage *) httpCookieStorage {
  return [TyphoonDefinition withClass:[NSHTTPCookieStorage class] configuration:^(TyphoonDefinition *definition) {
    [definition useInitializer:@selector(sharedHTTPCookieStorage)];
    definition.scope = TyphoonScopeSingleton;
  }];
}

- (NSNotificationCenter *) notificationCenter {
  return [TyphoonDefinition withClass:[NSNotificationCenter class] configuration:^(TyphoonDefinition *definition) {
    [definition useInitializer:@selector(defaultCenter)];
    definition.scope = TyphoonScopeSingleton;
  }];
}

- (UIApplication *) application {
  return [TyphoonDefinition withClass:[UIApplication class] configuration:^(TyphoonDefinition *definition) {
    [definition useInitializer:@selector(sharedApplication)];
    definition.scope = TyphoonScopeSingleton;
  }];
}

- (NSFileManager *) fileManager {
  return [TyphoonDefinition withClass:[NSFileManager class] configuration:^(TyphoonDefinition *definition) {
    [definition useInitializer:@selector(defaultManager)];
    definition.scope = TyphoonScopeSingleton;
  }];
}

- (UIWindow *) mainWindow {
  return [TyphoonDefinition withClass:[UIWindow class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition useInitializer:@selector(initWithFrame:)
                                          parameters:^(TyphoonMethod *initializer) {
                                            [initializer injectParameterWith:[NSValue valueWithCGRect:[[UIScreen mainScreen] bounds]]];
                                          }];
                          definition.scope = TyphoonScopeSingleton;
                        }];
}

- (NSBundle *) mainBundle {
  return [TyphoonDefinition withClass:[NSBundle class] configuration:^(TyphoonDefinition *definition) {
    [definition useInitializer:@selector(mainBundle)];
    definition.scope = TyphoonScopeSingleton;
  }];
}

@end
