//
//  MEWconnectTokenTransfer.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 13/12/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "MEWconnectTokenTransfer.h"
#import "NSString+HexNSDecimalNumber.h"

static NSString *const kMEWconnectTokenTransferPrefix           = @"0xa9059cbb";
static NSInteger const kMEWconnectTokenTransferParametersLength = 128;
static NSInteger const kMEWconnectTokenTransferAddressLength    = 40;

@implementation MEWconnectTokenTransfer

+ (instancetype) tokenTransferWithData:(id)data {
  if (![data isKindOfClass:[NSString class]]) {
    return nil;
  }
  if (![data hasPrefix:kMEWconnectTokenTransferPrefix]) {
    return nil;
  }
  
  NSString *parameters = [data stringByReplacingOccurrencesOfString:kMEWconnectTokenTransferPrefix withString:@""];
  if ([parameters length] != kMEWconnectTokenTransferParametersLength) {
    return nil;
  }
  
  NSString *addressParameter = [parameters substringToIndex:kMEWconnectTokenTransferParametersLength / 2];
  NSString *amountParameter = [parameters substringFromIndex:kMEWconnectTokenTransferParametersLength / 2];
  
  NSString *address = [@"0x" stringByAppendingString:[addressParameter substringFromIndex:[addressParameter length] - kMEWconnectTokenTransferAddressLength]];
  NSDecimalNumber *amount = [amountParameter decimalNumberFromHexRepresentation];
  
  MEWconnectTokenTransfer *tokenTransfer = [[MEWconnectTokenTransfer alloc] init];
  tokenTransfer->_to = address;
  tokenTransfer->_decimalValue = amount;
  
  return tokenTransfer;
}

@end
