//
//  RequestConfiguratorsAssembly.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 21/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "RequestConfiguratorsAssembly.h"

#import "RESTRequestConfigurator.h"

static NSString *const kNodeURLPath     = @"https://api.myetherapi.com";
static NSString *const kTickerURLPath   = @"http://still-waters-52916.herokuapp.com";
static NSString *const kSimplexURLPath  = @"https://apiccswap.myetherwallet.com";

@implementation RequestConfiguratorsAssembly

#pragma mark - Option matcher

- (id<RequestConfigurator>)requestConfiguratorWithType:(NSNumber *)type {
  return [self requestConfiguratorWithType:type url:nil];
}

- (id<RequestConfigurator>)requestConfiguratorWithType:(NSNumber *)type url:(NSURL *)url {
  return [TyphoonDefinition withOption:type matcher:^(TyphoonOptionMatcher *matcher) {
    [matcher caseEqual:@(RequestConfigurationMyEtherAPIType)
                   use:[self myEtherAPIRequestConfigurator]];
    [matcher caseEqual:@(RequestConfigurationTickerAPIType)
                   use:[self tickerAPIRequestConfigurator]];
    [matcher caseEqual:@(RequestConfigurationSimplexAPIType)
                   use:[self simplexAPIRequestConfigurator]];
    [matcher caseEqual:@(RequestConfigurationSimplexWebType)
                   use:[self simplexWebRequestConfiguratorWithURL:url]];
  }];
}

- (id<RequestConfigurator>) myEtherAPIRequestConfigurator {
  return [TyphoonDefinition withClass:[RESTRequestConfigurator class] configuration:^(TyphoonDefinition *definition) {
    [definition useInitializer:@selector(initWithBaseURL:apiPath:) parameters:^(TyphoonMethod *initializer) {
      [initializer injectParameterWith:[NSURL URLWithString:kNodeURLPath]];
      [initializer injectParameterWith:nil];
    }];
  }];
}

- (id<RequestConfigurator>) tickerAPIRequestConfigurator {
  return [TyphoonDefinition withClass:[RESTRequestConfigurator class] configuration:^(TyphoonDefinition *definition) {
    [definition useInitializer:@selector(initWithBaseURL:apiPath:) parameters:^(TyphoonMethod *initializer) {
      [initializer injectParameterWith:[NSURL URLWithString:kTickerURLPath]];
      [initializer injectParameterWith:nil];
    }];
  }];
}

- (id<RequestConfigurator>) simplexAPIRequestConfigurator {
  return [TyphoonDefinition withClass:[RESTRequestConfigurator class] configuration:^(TyphoonDefinition *definition) {
    [definition useInitializer:@selector(initWithBaseURL:apiPath:) parameters:^(TyphoonMethod *initializer) {
      [initializer injectParameterWith:[NSURL URLWithString:kSimplexURLPath]];
      [initializer injectParameterWith:nil];
    }];
  }];
}

- (id<RequestConfigurator>) simplexWebRequestConfiguratorWithURL:(NSURL *)url {
  return [TyphoonDefinition withClass:[RESTRequestConfigurator class] configuration:^(TyphoonDefinition *definition) {
    [definition useInitializer:@selector(initWithBaseURL:apiPath:) parameters:^(TyphoonMethod *initializer) {
      [initializer injectParameterWith:url];
      [initializer injectParameterWith:nil];
    }];
  }];
}

@end
