//
//  MEWConnectTransaction.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 04/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "MEWConnectTransaction.h"
#import "NSString+HexNSDecimalNumber.h"

@implementation MEWConnectTransaction

+ (instancetype)transactionWithJSONString:(NSString *)string {
  MEWConnectTransaction *transaction = [[[self class] alloc] init];
  NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
  NSDictionary *info = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
  transaction->_chainId   = info[@"chainId"];
  transaction->_data      = info[@"data"];
  transaction->_gasLimit  = info[@"gasLimit"];
  transaction->_gasPrice  = info[@"gasPrice"];
  transaction->_nonce     = info[@"nonce"];
  transaction->_to        = info[@"to"];
  transaction->_value     = info[@"value"];
  
  return transaction;
}

- (NSDecimalNumber *)decimalValue {
  NSDecimalNumber *divider = [NSDecimalNumber decimalNumberWithString:@"1000000000000000000"];
  return [[self.value decimalNumberFromHexRepresentation] decimalNumberByDividingBy:divider];
}

@end
