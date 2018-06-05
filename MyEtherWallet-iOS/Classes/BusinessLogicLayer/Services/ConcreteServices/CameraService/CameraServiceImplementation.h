//
//  CameraServiceImplementation.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 19/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "CameraService.h"

@class AVCaptureSession;

@interface CameraServiceImplementation : NSObject <CameraService>
- (instancetype) initWithSession:(AVCaptureSession *)session
           captureMetadataOutput:(AVCaptureMetadataOutput *)metadataOutput
                       mediaType:(AVMediaType)mediaType;
@end
