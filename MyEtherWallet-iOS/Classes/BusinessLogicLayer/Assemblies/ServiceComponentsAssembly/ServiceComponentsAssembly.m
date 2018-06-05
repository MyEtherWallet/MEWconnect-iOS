//
//  ServiceComponentsAssembly.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 15/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import WebRTC;

#import "ResponseMappersFactory.h"
#import "ServiceComponentsAssembly.h"
#import "OperationFactoriesAssembly.h"

#import "MEWConnectServiceImplementation.h"
#import "MEWRTCServiceImplementation.h"
#import "MEWCryptoImplementation.h"
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
                          [definition injectProperty:@selector(cryptoService) with:[self MEWCrypto]];
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

- (id<MEWCrypto>)MEWCrypto {
  return [TyphoonDefinition withClass:[MEWCryptoImplementation class]];
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
