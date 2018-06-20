//
//  ServiceComponentsAssembly.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 15/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import WebRTC;

#import "MyEtherWallet_iOS-Swift.h"

#import "ResponseMappersFactory.h"
#import "ServiceComponentsAssembly.h"
#import "OperationFactoriesAssembly.h"

#import "MEWConnectServiceImplementation.h"
#import "MEWRTCServiceImplementation.h"
#import "MEWcryptoImplementation.h"
#import "MEWWalletImplementation.h"
#import "MEWConnectFacadeImplementation.h"

#import "TokensServiceImplementation.h"

#import "CameraServiceImplementation.h"

#import "OperationSchedulerImplementation.h"

@implementation ServiceComponentsAssembly

#pragma mark - MEW

- (id<MEWConnectFacade>) MEWConnectFacade {
  return [TyphoonDefinition withClass:[MEWConnectFacadeImplementation class]
                        configuration:^(TyphoonDefinition *definition) {
                          definition.scope = TyphoonScopeSingleton;
                          [definition injectProperty:@selector(connectService) with:[self MEWConnectService]];
                          [definition injectProperty:@selector(walletService) with:[self MEWWallet]];
                        }];
}

- (id <MEWConnectService>) MEWConnectService {
  return [TyphoonDefinition withClass:[MEWConnectServiceImplementation class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition useInitializer:@selector(initWithMapper:)
                                          parameters:^(TyphoonMethod *initializer) {
                                            [initializer injectParameterWith:[self.responseMappersFactory mapperWithType:@(ResponseMappingMEWConnectType)]];
                                          }];
                          [definition injectProperty:@selector(rtcService)
                                                with:[self MEWRTCService]];
                          [definition injectProperty:@selector(MEWcrypto)
                                                with:[self MEWcrypto]];
                          [definition injectProperty:@selector(delegate) with:[self MEWConnectFacade]];
                        }];
}

- (id<MEWRTCService>)MEWRTCService {
  return [TyphoonDefinition withClass:[MEWRTCServiceImplementation class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(peerConnectionFactory)
                                                with:[self peerConnectionFactory]];
                          [definition injectProperty:@selector(delegate)
                                                with:[self MEWConnectService]];
                        }];
}

- (id<MEWWallet>)MEWWallet {
  return [TyphoonDefinition withClass:[MEWWalletImplementation class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(wrapper)
                                                with:[self web3Wrapper]];
                        }];
}

- (Web3Wrapper *) web3Wrapper {
  return [TyphoonDefinition withClass:[Web3Wrapper class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(MEWcrypto)
                                                with:[self MEWcrypto]];
                        }];
}

- (id<MEWcrypto>) MEWcrypto {
  return [TyphoonDefinition withClass:[MEWcryptoImplementation class]];
}

#pragma mark - Ethereum

- (id<TokensService>)tokensService {
  return [TyphoonDefinition withClass:[TokensServiceImplementation class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(tokensOperationFactory)
                                                with:[self.operationFactoriesAssembly tokensOperationFactory]];
                          [definition injectProperty:@selector(operationScheduler)
                                                with:[self operationScheduler]];
                        }];
}

#pragma mark - Other Services

- (id<CameraService>) cameraServiceWithDelegate:(id <CameraServiceDelegate>)delegate {
  return [TyphoonDefinition withClass:[CameraServiceImplementation class] configuration:^(TyphoonDefinition <AVCaptureMetadataOutputObjectsDelegate> *definition) {
    [definition useInitializer:@selector(initWithSession:captureMetadataOutput:mediaType:) parameters:^(TyphoonMethod *initializer) {
      [initializer injectParameterWith:[self captureSession]];
      [initializer injectParameterWith:[self captureMetadataOutput]];
      [initializer injectParameterWith:AVMediaTypeVideo];
    }];
    [definition injectProperty:@selector(delegate) with:delegate];
  }];
}

#pragma mark - Helpers

- (RTCPeerConnectionFactory *) peerConnectionFactory {
  return [TyphoonDefinition withClass:[RTCPeerConnectionFactory class]];
}

- (id <OperationScheduler>) operationScheduler
{
  return [TyphoonDefinition withClass:[OperationSchedulerImplementation class]];
}

#pragma mark - AVCapture

- (AVCaptureSession *) captureSession {
  return [TyphoonDefinition withClass:[AVCaptureSession class]];
}

- (AVCaptureMetadataOutput *) captureMetadataOutput {
  return [TyphoonDefinition withClass:[AVCaptureMetadataOutput class]];
}

@end
