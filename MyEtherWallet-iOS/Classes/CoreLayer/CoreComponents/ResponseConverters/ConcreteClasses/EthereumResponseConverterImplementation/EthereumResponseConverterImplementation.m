//
//  EthereumResponseConverterImplementation.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "EthereumResponseConverterImplementation.h"

#import "NSString+HexNSDecimalNumber.h"

static NSString *const kEthereumResponseBalance   = @"balance";
static NSString *const kEthereumResponseDecimals  = @"decimals";
static NSString *const kEthereumResponseName      = @"name";
static NSString *const kEthereumResponseSymbol    = @"symbol";

static NSString *const kEthereumResponseResult    = @"result";

@implementation EthereumResponseConverterImplementation

- (id)convertFromResponse:(id)response error:(NSError *__autoreleasing *)error {
  NSDecimalNumber *balance = [response[kEthereumResponseResult] decimalNumberFromHexRepresentation];
  NSDictionary *converted = @{kEthereumResponseBalance: balance,
                              kEthereumResponseDecimals: @18,
                              kEthereumResponseSymbol: @"ETH",
                              kEthereumResponseName: @"Ethereum"};
  return @{kEthereumResponseResult: @[converted]};
}

@end
