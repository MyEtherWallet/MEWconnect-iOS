//
//  MEWConnectTransaction.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 04/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "MEWConnectTransaction.h"
#import "NSString+HexNSDecimalNumber.h"

#import "MEWconnectTokenTransfer.h"

#import "TokenPlainObject.h"

static NSString *const kMEWconnectTransactionTransferPrefix = @"0xa9059cbb";

static NSString *const kMEWconnectTransactionChainId  = @"chainId";
static NSString *const kMEWconnectTransactionData     = @"data";
static NSString *const kMEWconnectTransactionGas      = @"gas";
static NSString *const kMEWconnectTransactionGasPrice = @"gasPrice";
static NSString *const kMEWconnectTransactionNonce    = @"nonce";
static NSString *const kMEWconnectTransactionTo       = @"to";
static NSString *const kMEWconnectTransactionValue    = @"value";

@interface MEWConnectTransaction ()
@property (nonatomic, strong) MEWconnectTokenTransfer *tokenTransferInformation;
@end

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
  
  transaction.tokenTransferInformation = [MEWconnectTokenTransfer tokenTransferWithData:transaction->_data];
  
  return transaction;
}

- (BOOL)isTransfer {
  return self.tokenTransferInformation != nil;
}

- (NSDecimalNumber *) decimalValue {
  NSDecimalNumber *decimalValue = nil;
  if (self.tokenTransferInformation) {
    decimalValue = self.tokenTransferInformation.decimalValue;
  } else {
    decimalValue = [self.value decimalNumberFromHexRepresentation];
  }
  if (!self.token.decimals) {
    return decimalValue;
  }
  NSDecimalNumber *decimals = [NSDecimalNumber decimalNumberWithMantissa:1 exponent:[self.token.decimals shortValue] isNegative:NO];
  if ([decimals compare:[NSDecimalNumber zero]] == NSOrderedSame) {
    decimals = [NSDecimalNumber one];
  }
  decimalValue = [decimalValue decimalNumberByDividingBy:decimals];
  return decimalValue;
}

- (NSString *) toValue {
  if (self.tokenTransferInformation) {
    return self.tokenTransferInformation.to;
  } else {
    return self.to;
  }
}

@end
