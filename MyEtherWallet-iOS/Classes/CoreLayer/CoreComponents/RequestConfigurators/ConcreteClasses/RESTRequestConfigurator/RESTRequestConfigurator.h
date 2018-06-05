//
//  RESTRequestConfigurator.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 21/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import AFNetworking.AFURLRequestSerialization;

#import "RequestConfigurator.h"

@interface RESTRequestConfigurator : AFHTTPRequestSerializer <RequestConfigurator>
@property (nonatomic, copy, readonly) NSURL *baseURL;
@property (nonatomic, copy, readonly) NSString *apiPath;
- (instancetype)initWithBaseURL:(NSURL *)baseURL apiPath:(NSString *)apiPath;
@end
