//
//  RequestConfiguratorsAssembly.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 21/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "RequestConfiguratorsAssembly.h"

#import "RESTRequestConfigurator.h"

static NSString *const kConfigFileName    = @"MEWconnect.API.plist";

static NSString *const kNodeURLKey        = @"API.NodeURL";
static NSString *const kTickerURLKey      = @"API.TickerURL";
static NSString *const kSimplexAPIURLKey  = @"API.SimplexAPIURL";

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
      [initializer injectParameterWith:TyphoonConfig(kNodeURLKey)];
      [initializer injectParameterWith:nil];
    }];
  }];
}

- (id<RequestConfigurator>) tickerAPIRequestConfigurator {
  return [TyphoonDefinition withClass:[RESTRequestConfigurator class] configuration:^(TyphoonDefinition *definition) {
    [definition useInitializer:@selector(initWithBaseURL:apiPath:) parameters:^(TyphoonMethod *initializer) {
      [initializer injectParameterWith:TyphoonConfig(kTickerURLKey)];
      [initializer injectParameterWith:nil];
    }];
  }];
}

- (id<RequestConfigurator>) simplexAPIRequestConfigurator {
  return [TyphoonDefinition withClass:[RESTRequestConfigurator class] configuration:^(TyphoonDefinition *definition) {
    [definition useInitializer:@selector(initWithBaseURL:apiPath:) parameters:^(TyphoonMethod *initializer) {
      [initializer injectParameterWith:TyphoonConfig(kSimplexAPIURLKey)];
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

#pragma mark - Config

- (id)configurer {
  return [TyphoonDefinition withConfigName:kConfigFileName];
}

@end
