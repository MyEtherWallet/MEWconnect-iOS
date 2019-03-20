//
//  WalletUIStringAttributesProvider.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 3/19/19.
//  Copyright © 2019 MyEtherWallet, Inc. All rights reserved.
//

#import "UIStringAttributesProvider.h"

NS_ASSUME_NONNULL_BEGIN

@interface WalletUIStringAttributesProvider : UIStringAttributesProvider

#pragma mark - QRScanner

@property (class, copy, readonly) NSDictionary<NSAttributedStringKey, id> *qrScannerMediumTitleAttributes;
@property (class, copy, readonly) NSDictionary<NSAttributedStringKey, id> *qrScannerBoldTitleAttributes;
@property (class, copy, readonly) NSDictionary<NSAttributedStringKey, id> *qrScannerRegularDescriptionAttributes;
@property (class, copy, readonly) NSDictionary<NSAttributedStringKey, id> *qrScannerWarningAttributes;
@property (class, copy, readonly) NSDictionary<NSAttributedStringKey, id> *qrScannerWarningLinkAttributes;
@end

NS_ASSUME_NONNULL_END
