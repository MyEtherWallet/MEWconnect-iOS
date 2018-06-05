//
//  QRScannerViewController.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import UIKit;

#import "QRScannerViewInput.h"

@protocol QRScannerViewOutput;
@interface QRScannerViewController : UIViewController <QRScannerViewInput>
@property (nonatomic, strong) id <QRScannerViewOutput> output;
@property (nonatomic, strong) id <UIViewControllerTransitioningDelegate> customTransitioningDelegate;
@end
