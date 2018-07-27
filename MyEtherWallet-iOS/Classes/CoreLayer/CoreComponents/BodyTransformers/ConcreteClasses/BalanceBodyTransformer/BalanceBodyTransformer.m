//
//  BalanceBodyTransformer.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 30/06/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#if BETA
#import "MyEtherWallet_iOS_Beta-Swift.h"
#else
#import "MyEtherWallet_iOS-Swift.h"
#endif

#import "BalanceBodyTransformer.h"

#import "AccountsBody.h"

@implementation BalanceBodyTransformer

- (NSData *)deriveDataFromBody:(AccountsBody *)body {
  return [Web3Wrapper balanceRequestForAddress:body.address];
}

@end
