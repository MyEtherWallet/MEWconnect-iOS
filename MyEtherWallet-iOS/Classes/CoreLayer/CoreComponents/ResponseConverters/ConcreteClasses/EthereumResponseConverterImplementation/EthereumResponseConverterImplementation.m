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
static NSString *const kEthereumResponseAddress   = @"address";

static NSString *const kEthereumResponseResult    = @"result";
static NSString *const kEthereumResponseId        = @"id";

@implementation EthereumResponseConverterImplementation

- (id)convertFromResponse:(id)response error:(__unused NSError *__autoreleasing *)error {
  NSDecimalNumber *balance = [response[kEthereumResponseResult] decimalNumberFromHexRepresentation];
  /* It's safe to use directly from response, because of validator */
  NSDictionary *converted = @{kEthereumResponseAddress: response[kEthereumResponseId],
                              kEthereumResponseBalance: balance,
                              kEthereumResponseDecimals: @18,
                              kEthereumResponseSymbol: @"ETH",
                              kEthereumResponseName: @"Ethereum"};
  return @{kEthereumResponseResult: @[converted]};
}

@end
