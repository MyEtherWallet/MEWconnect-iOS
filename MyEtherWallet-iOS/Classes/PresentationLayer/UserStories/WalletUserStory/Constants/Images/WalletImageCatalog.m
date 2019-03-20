//
//  WalletImageCatalog.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 3/19/19.
//  Copyright © 2019 MyEtherWallet, Inc. All rights reserved.
//

#import "WalletImageCatalog.h"

typedef NSString *WalletImageName NS_TYPED_ENUM;

static WalletImageName const kWalletQRScannerConnectionSuccessIcon = @"scan_success_icon";
static WalletImageName const kWalletQRScannerConnectionFailureIcon = @"scan_error_icon";

@implementation WalletImageCatalog

+ (UIImage *) qrScannerConnectionSuccess {
  return [UIImage imageNamed:kWalletQRScannerConnectionSuccessIcon];
}

+ (UIImage *) qrScannerConnectionFailure {
  return [UIImage imageNamed:kWalletQRScannerConnectionFailureIcon];
}

@end
