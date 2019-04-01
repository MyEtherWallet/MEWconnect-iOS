//
//  QRScannerStatusView.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 3/19/19.
//  Copyright © 2019 MyEtherWallet, Inc. All rights reserved.
//

@import UIKit;

NS_ASSUME_NONNULL_BEGIN

@class LinkedLabel;

typedef NS_ENUM(short, QRScannerStatusViewType) {
  QRScannerStatusViewInProgress   = 0,
  QRScannerStatusViewConnected    = 1,
  QRScannerStatusViewFailure      = 2,
  QRScannerStatusViewNoConnection = 3,
  QRScannerStatusViewNoAccess     = 4,
};

@interface QRScannerStatusView : UIView
@property (nonatomic, readonly) QRScannerStatusViewType type;
@property (nonatomic, weak, readonly, nullable) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, weak, readonly, nullable) UIButton *tryAgainButton;
@property (nonatomic, weak, readonly, nullable) UIButton *contactSupportButton;
@property (nonatomic, weak, readonly, nullable) LinkedLabel *settingsLinkedLabel;
+ (instancetype) statusViewWithType:(QRScannerStatusViewType)type;
@end

NS_ASSUME_NONNULL_END
