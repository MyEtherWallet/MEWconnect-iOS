//
//  WalletUIStringList.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 3/19/19.
//  Copyright © 2019 MyEtherWallet, Inc. All rights reserved.
//

#import "WalletUIStringList.h"

@implementation WalletUIStringList

#pragma mark - QRScanner

+ (NSString *) qrScannerInProgressTitle {
  return NSLocalizedString(@"Creating a local connection\nwith MyEtherWallet", @"QRScanner. In progress title");
}

+ (NSString *) qrScannerFailureTitle {
  return NSLocalizedString(@"Can't connect", @"QRScanner. Failure title");
}

+ (NSString *) qrScannerSuccessTitle {
  return NSLocalizedString(@"Connected to MyEtherWallet", @"QRScanner. Connection success title");
}

+ (NSString *) qrScannerSuccessDescription {
  return NSLocalizedString(@"Via encrypted peer-to-peer\nconnection", @"QRScanner. Connection success description");
}

+ (NSString *) qrScannerTryAgainTitle {
  return NSLocalizedString(@"Try again", @"QRScanner. Failure action").uppercaseString;
}

+ (NSString *) qrScannerContactSupportTitle {
  return NSLocalizedString(@"Contact support", @"QRScanner. contact support");
}

+ (NSString *) qrScannerNoAccessTitle {
  return NSLocalizedString(@"Please enable camera access\nfor MEWconnect in Settings", @"QRScanner. Access to camera warning");
}

+ (NSArray<NSString *> *) qrScannerNoAccessTitleLinked {
  NSString *linkedPartsString = NSLocalizedString(@"Settings", @"QR Scanner. Access to camera warning. Linked parts separated by '|'");
  NSArray <NSString *> *linkedParts = [linkedPartsString componentsSeparatedByString:@"|"];
  return linkedParts;
}

@end
