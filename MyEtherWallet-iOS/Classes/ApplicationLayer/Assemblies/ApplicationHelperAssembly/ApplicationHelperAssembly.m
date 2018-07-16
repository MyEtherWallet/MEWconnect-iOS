//
//  ApplicationHelperAssembly.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 15/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "ApplicationHelperAssembly.h"

#import "StoryboardsAssembly.h"
#import "NavigationControllerFactoryImplementation.h"

@implementation ApplicationHelperAssembly

- (id<NavigationControllerFactory>)navigationControllerFactory {
  return [TyphoonDefinition withClass:[NavigationControllerFactoryImplementation class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition useInitializer:@selector(factoryWithStoryboard:)
                                          parameters:^(TyphoonMethod *initializer) {
                                            [initializer injectParameterWith:[self.storyboardAssembly mainStoryboard]];
                                          }];
                          [definition injectProperty:@selector(walletStoryboard) with:[self.storyboardAssembly walletStoryboard]];
                        }];
}

@end
