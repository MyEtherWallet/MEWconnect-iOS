//
//  RequestConfiguratorsAssembly.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 21/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "RequestConfiguratorsAssembly.h"

#import "RESTRequestConfigurator.h"

static NSString *const kNodeURLPath    = @"https://api.myetherapi.com";

@implementation RequestConfiguratorsAssembly

#pragma mark - Option matcher

- (id<RequestConfigurator>)requestConfiguratorWithType:(NSNumber *)type {
  return [TyphoonDefinition withOption:type matcher:^(TyphoonOptionMatcher *matcher) {
    [matcher caseEqual:@(RequestConfigurationRestType)
                   use:[self restRequestConfigurator]];
  }];
}

- (id<RequestConfigurator>)restRequestConfigurator {
  return [TyphoonDefinition withClass:[RESTRequestConfigurator class] configuration:^(TyphoonDefinition *definition) {
    [definition useInitializer:@selector(initWithBaseURL:apiPath:) parameters:^(TyphoonMethod *initializer) {
      [initializer injectParameterWith:[NSURL URLWithString:kNodeURLPath]];
      [initializer injectParameterWith:nil];
    }];
  }];
}

@end
