//
//  ConfirmationUIStringList.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 3/20/19.
//  Copyright © 2019 MyEtherWallet, Inc. All rights reserved.
//

#import "ConfirmationUIStringList.h"

@implementation ConfirmationUIStringList

+ (NSString *) confirmationUnknownTokenCurrencySymbol {
  return NSLocalizedString(@"Unknown Token", @"Transaction screen. Unknown token symbol");
}

+ (NSString *) confirmationUnknownTokenDescription {
  return NSLocalizedString(@"Amount in fractional units", @"Transaction screen. Unknown token decimals");
}

+ (NSString *) confirmationCheckAddressShortVersion {
  return NSLocalizedString(@"Check address:", @"Transaction screen. Check address title. 4.0inch");
}

+ (NSString *) confirmationCheckAddressFullVersion {
  return NSLocalizedString(@"Check address you’re sending to:", @"Transaction screen. Check address title");
}

+ (NSString *) confirmationCheckAmount {
  return NSLocalizedString(@"Check the amount:", @"Transaction screen. Check amount title");
}

+ (NSString *) confirmationCheckNetwork {
  return NSLocalizedString(@"Check network:", @"Transaction screen. Check network title");
}

@end
