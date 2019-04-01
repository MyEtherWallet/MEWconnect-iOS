//
//  WalletImageCatalog.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 3/19/19.
//  Copyright © 2019 MyEtherWallet, Inc. All rights reserved.
//

#import "WalletImageCatalog.h"

typedef NSString *WalletImageName NS_TYPED_ENUM;

static WalletImageName const kWalletQRScannerConnectionSuccessIcon = @"big_checkmark";
static WalletImageName const kWalletQRScannerConnectionFailureIcon = @"scan_error_icon";

static WalletImageName const kWalletShareToastIcon = @"big_checkmark";

@implementation WalletImageCatalog

#pragma mark - QRScanner

+ (UIImage *) qrScannerConnectionSuccess {
  return [UIImage imageNamed:kWalletQRScannerConnectionSuccessIcon];
}

+ (UIImage *) qrScannerConnectionFailure {
  return [UIImage imageNamed:kWalletQRScannerConnectionFailureIcon];
}

#pragma mark - Share

+ (UIImage *) shareToastIcon {
  return [UIImage imageNamed:kWalletShareToastIcon];
}

@end
