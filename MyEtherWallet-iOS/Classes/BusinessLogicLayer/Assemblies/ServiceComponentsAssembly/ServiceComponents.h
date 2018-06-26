//
//  ServiceComponents.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 15/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@protocol MEWConnectFacade;
@protocol MEWcrypto;
@protocol MEWwallet;
@protocol CameraService;
@protocol CameraServiceDelegate;
@protocol TokensService;

@protocol ServiceComponents <NSObject>
- (id <MEWConnectFacade>) MEWConnectFacade;
- (id <MEWwallet>) MEWWallet;
- (id <MEWcrypto>) MEWcrypto;
- (id <CameraService>) cameraServiceWithDelegate:(id <CameraServiceDelegate>)delegate;
- (id <TokensService>) tokensService;
@end
