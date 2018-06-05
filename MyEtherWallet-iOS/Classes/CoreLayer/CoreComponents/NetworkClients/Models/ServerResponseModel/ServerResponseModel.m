//
//  ServerResponseModel.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 21/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "ServerResponseModel.h"

@interface ServerResponseModel ()
@property (nonatomic, strong, readwrite) NSHTTPURLResponse *response;
@property (nonatomic, strong, readwrite) NSData *data;
@end

@implementation ServerResponseModel

- (instancetype)initWithResponse:(NSHTTPURLResponse *)response
                            data:(NSData *)data {
  self = [super init];
  if (self) {
    _response = response;
    _data = data;
  }
  return self;
}

@end
