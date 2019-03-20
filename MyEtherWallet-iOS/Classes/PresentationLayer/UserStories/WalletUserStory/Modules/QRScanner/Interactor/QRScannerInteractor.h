//
//  QRScannerInteractor.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "QRScannerInteractorInput.h"
#import "CameraServiceDelegate.h"

#import "ReachabilityServiceDelegate.h"

@protocol QRScannerInteractorOutput;
@protocol MEWConnectFacade;
@protocol CameraService;
@protocol ReachabilityService;

@interface QRScannerInteractor : NSObject <QRScannerInteractorInput, CameraServiceDelegate, ReachabilityServiceDelegate>
@property (nonatomic, weak) id<QRScannerInteractorOutput> output;
@property (nonatomic, strong) id <MEWConnectFacade> connectFacade;
@property (nonatomic, strong) id <CameraService> cameraService;
@property (nonatomic, strong) id <ReachabilityService> reachabilityService;
@end
