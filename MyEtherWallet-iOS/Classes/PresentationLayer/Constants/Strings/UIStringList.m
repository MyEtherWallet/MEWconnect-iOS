//
//  UIStringList.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 3/19/19.
//  Copyright © 2019 MyEtherWallet, Inc. All rights reserved.
//

#import "UIStringList.h"

@implementation UIStringList

+ (NSString *) noInternetConnection {
  return NSLocalizedString(@"No internet connection", @"Shared (Home, QRScanner). No internet connection");
}

+ (NSString *) cancel {
  return NSLocalizedString(@"Cancel", @"Shared (Home - Network selection). Cancel title");
}

@end
