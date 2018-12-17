//
//  AccountToAccountV2Policy.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 27/10/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "AccountToAccountV2Policy.h"

@implementation AccountToAccountV2Policy

- (NSString *) UUID {
  return [[NSUUID UUID] UUIDString];
}

@end
