//
//  RequestDataModel.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 21/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "RequestDataModel.h"

@implementation RequestDataModel

- (instancetype)initWithHTTPHeaderFields:(NSDictionary *)HTTPHeaderFields
                         queryParameters:(NSDictionary *)queryParameters
                                bodyData:(NSData *)bodyData {
  self = [super init];
  
  if (self) {
    _HTTPHeaderFields = HTTPHeaderFields;
    _queryParameters = queryParameters;
    _bodyData = bodyData;
  }
  
  return self;
}

@end
