//
//  ManyResponseValidator.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 21/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "ManyResponseValidator.h"

@implementation ManyResponseValidator

- (NSError *)validateServerResponse:(id)response {
  NSError *resultError = nil;
  
  if(![super validateResponseIsArrayClass:response error:&resultError]) {
    return resultError;
  } else {
    return nil;
  }
  
  return resultError;
}

@end
