//
//  RequestConfigurationOperation.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 21/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "AsyncOperation.h"

#import "ChainableOperation.h"

@protocol RequestConfigurator;

@interface RequestConfigurationOperation : AsyncOperation <ChainableOperation>
+ (instancetype)operationWithRequestConfigurator:(id<RequestConfigurator>)configurator
                                          method:(NSString *)method
                                     serviceName:(NSString *)serviceName
                                   urlParameters:(NSArray *)urlParameters;
@end
