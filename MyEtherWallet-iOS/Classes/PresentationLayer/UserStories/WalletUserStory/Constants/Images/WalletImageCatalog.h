//
//  WalletImageCatalog.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 3/19/19.
//  Copyright © 2019 MyEtherWallet, Inc. All rights reserved.
//

#import "ImageCatalog.h"

NS_ASSUME_NONNULL_BEGIN

@interface WalletImageCatalog : ImageCatalog

#pragma mark - QRScanner

@property (class, strong, readonly) UIImage *qrScannerConnectionSuccess;
@property (class, strong, readonly) UIImage *qrScannerConnectionFailure;

@end

NS_ASSUME_NONNULL_END
