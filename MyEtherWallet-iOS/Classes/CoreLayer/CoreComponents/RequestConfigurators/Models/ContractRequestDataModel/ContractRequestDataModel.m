//
//  ContractRequestDataModelRequestDataModel.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 21/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "ContractRequestDataModel.h"

@implementation ContractRequestDataModel

- (instancetype)initWithContractAddresses:(NSArray *)addresses
                                      abi:(NSString *)abi
                               abiVersion:(NSInteger)abiVersion
                               parameters:(NSArray *)parameters
                                  methods:(NSString *)method {
  self = [super init];
  if (self) {
    _contractAddresses = addresses;
    _abi = abi;
    _abiVersion = abiVersion;
    _parameters = parameters;
    _method = method;
  }
  return self;
}

@end
