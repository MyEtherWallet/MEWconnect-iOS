//
//  MEWConnectTransaction.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 04/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "MEWConnectTransaction.h"
#import "NSString+HexNSDecimalNumber.h"

static NSString *const kMEWconnectTransactionChainId  = @"chainId";
static NSString *const kMEWconnectTransactionData     = @"data";
static NSString *const kMEWconnectTransactionGas      = @"gas";
static NSString *const kMEWconnectTransactionGasPrice = @"gasPrice";
static NSString *const kMEWconnectTransactionNonce    = @"nonce";
static NSString *const kMEWconnectTransactionTo       = @"to";
static NSString *const kMEWconnectTransactionValue    = @"value";

@implementation MEWConnectTransaction

+ (instancetype)transactionWithJSONString:(NSString *)string {
  MEWConnectTransaction *transaction = [[[self class] alloc] init];
  NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
  NSDictionary *info = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
  transaction->_chainId   = info[kMEWconnectTransactionChainId];
  transaction->_data      = info[kMEWconnectTransactionData];
  transaction->_gas       = info[kMEWconnectTransactionGas];
  transaction->_gasPrice  = info[kMEWconnectTransactionGasPrice];
  transaction->_nonce     = info[kMEWconnectTransactionNonce];
  transaction->_to        = info[kMEWconnectTransactionTo];
  transaction->_value     = info[kMEWconnectTransactionValue];
  
  return transaction;
}

- (NSDecimalNumber *)decimalValue {
  NSDecimalNumber *divider = [NSDecimalNumber decimalNumberWithString:@"1000000000000000000"];
  return [[self.value decimalNumberFromHexRepresentation] decimalNumberByDividingBy:divider];
}

@end
