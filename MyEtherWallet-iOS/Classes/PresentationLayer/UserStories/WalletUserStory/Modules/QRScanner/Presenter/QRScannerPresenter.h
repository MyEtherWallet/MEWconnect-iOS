//
//  QRScannerPresenter.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "QRScannerViewOutput.h"
#import "QRScannerInteractorOutput.h"
#import "QRScannerModuleInput.h"

@protocol QRScannerViewInput;
@protocol QRScannerInteractorInput;
@protocol QRScannerRouterInput;

@interface QRScannerPresenter : NSObject <QRScannerModuleInput, QRScannerViewOutput, QRScannerInteractorOutput>

@property (nonatomic, weak) id<QRScannerViewInput> view;
@property (nonatomic, strong) id<QRScannerInteractorInput> interactor;
@property (nonatomic, strong) id<QRScannerRouterInput> router;

@end
