//
//  TokensBodyTransformer.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 21/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#if BETA
#import "MyEtherWallet_iOS_Beta-Swift.h"
#else
#import "MyEtherWallet_iOS-Swift.h"
#endif
#import "TokensBodyTransformer.h"

#import "TokensBody.h"
#import "MasterTokenBody.h"

@implementation TokensBodyTransformer

- (NSData *) deriveDataFromBody:(id)body {
  if ([body isKindOfClass:[TokensBody class]]) {
    TokensBody *tokensBody = (TokensBody *)body;
    return [Web3Wrapper contractRequestForAddress:tokensBody.address
                                contractAddresses:tokensBody.contractAddresses
                                              abi:tokensBody.abi
                                           method:tokensBody.method
                                          options:@[@(tokensBody.nameRequired),
                                                    @(tokensBody.websiteRequired),
                                                    @(tokensBody.emailRequired),
                                                    @(tokensBody.count)]
                                transactionFields:@[@"data", @"to"]];
  } else if ([body isKindOfClass:[MasterTokenBody class]]) {
    MasterTokenBody *masterTokenBody = (MasterTokenBody *)body;
    return [Web3Wrapper balanceRequestForAddress:masterTokenBody.address];
  }
  return nil;
}

@end
