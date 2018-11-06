//
//  RESTRequestConfigurator.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 21/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "RESTRequestConfigurator.h"

#import "RequestDataModel.h"

@interface RESTRequestConfigurator ()
@property (nonatomic, copy) NSURL *baseURL;
@property (nonatomic, copy) NSString *apiPath;
@end

@implementation RESTRequestConfigurator

#pragma mark - Initialization

- (instancetype)initWithBaseURL:(NSURL *)baseURL
                        apiPath:(NSString *)apiPath {
  self = [super init];
  if (self) {
    _baseURL = [baseURL copy];
    _apiPath = [apiPath copy];
  }
  return self;
}

#pragma mark - RequestConfigurator

- (NSURLRequest *)requestWithMethod:(NSString *)method
                        serviceName:(NSString *)serviceName
                      urlParameters:(NSArray *)urlParameters
                   requestDataModel:(RequestDataModel *)requestDataModel {
  NSURL *finalURL = [self generateURLWithServiceName:serviceName
                                       urlParameters:urlParameters];
  NSMutableURLRequest *mutableRequest = [NSMutableURLRequest requestWithURL:finalURL];
  [mutableRequest setHTTPMethod:method];
  
  [requestDataModel.HTTPHeaderFields enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, __unused BOOL * _Nonnull stop) {
    [mutableRequest setValue:obj forHTTPHeaderField:key];
  }];
  
  NSURLRequest *request;
  if (requestDataModel.bodyData) {
    [mutableRequest setHTTPBody:requestDataModel.bodyData];
    request = [mutableRequest copy];
  } else {
    request = [self requestBySerializingRequest:[mutableRequest copy]
                                 withParameters:requestDataModel.queryParameters
                                          error:nil];
  }
  
  return request;
}

#pragma mark - Helper Methods

- (NSURL *)generateURLWithServiceName:(NSString *)serviceName
                        urlParameters:(NSArray *)urlParameters {
  NSMutableArray *urlParts = [NSMutableArray new];
  
  if (self.apiPath) {
    [urlParts addObject:self.apiPath];
  }
  if (serviceName) {
    [urlParts addObject:serviceName];
  }
  
  [urlParts addObjectsFromArray:urlParameters];
  
  NSString *urlPath = [urlParts componentsJoinedByString:@"/"];
  urlPath = [self filterSlashesInURLPath:urlPath];
  
  NSURL *finalURL = [self.baseURL URLByAppendingPathComponent:urlPath];
  return finalURL;
}

- (NSString *)filterSlashesInURLPath:(NSString *)urlPath {
  NSString *filteredPath = [urlPath stringByReplacingOccurrencesOfString:@"//" withString:@"/"];
  
  return filteredPath;
}

#pragma mark - Debug

- (NSString *)debugDescription {
  return [NSString stringWithFormat:@"BaseURL: %@;\napiPath: %@", self.baseURL, self.apiPath];
}

@end
