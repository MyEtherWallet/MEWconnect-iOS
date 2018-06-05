//
//  SingleResponseValidator.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 21/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "SingleResponseValidator.h"

@implementation SingleResponseValidator

- (NSError *)validateServerResponse:(id)response {
  NSError *resultError = nil;
  
  if(![super validateResponseIsDictionaryClass:response error:&resultError]) {
    return resultError;
  }
  
  return resultError;
}

@end
