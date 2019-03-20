//
//  WalletUIStringList.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 3/19/19.
//  Copyright © 2019 MyEtherWallet, Inc. All rights reserved.
//

#import "UIStringList.h"

NS_ASSUME_NONNULL_BEGIN

@interface WalletUIStringList : UIStringList

#pragma mark - QRScanner

@property (class, strong, readonly) NSString *qrScannerInProgressTitle;
@property (class, strong, readonly) NSString *qrScannerFailureTitle;
@property (class, strong, readonly) NSString *qrScannerSuccessTitle;
@property (class, strong, readonly) NSString *qrScannerSuccessDescription;
@property (class, strong, readonly) NSString *qrScannerTryAgainTitle;
@property (class, strong, readonly) NSString *qrScannerContactSupportTitle;
@property (class, strong, readonly) NSString *qrScannerNoAccessTitle;
@property (class, strong, readonly) NSArray <NSString *> *qrScannerNoAccessTitleLinked;

@end

NS_ASSUME_NONNULL_END
