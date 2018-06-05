//
//  RequestDataModel.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 21/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@interface RequestDataModel : NSObject
@property (nonatomic, strong) NSDictionary *HTTPHeaderFields;
@property (nonatomic, strong) NSDictionary *queryParameters;
@property (nonatomic, strong) NSData *bodyData;

- (instancetype)initWithHTTPHeaderFields:(NSDictionary *)HTTPHeaderFields
                         queryParameters:(NSDictionary *)queryParameters
                                bodyData:(NSData *)bodyData;
@end
