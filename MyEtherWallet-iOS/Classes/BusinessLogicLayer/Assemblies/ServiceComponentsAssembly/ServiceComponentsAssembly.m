//
//  ServiceComponentsAssembly.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 15/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import WebRTC;
@import UICKeyChainStore;

#import "ApplicationConstants.h"

#if BETA
#import "MyEtherWallet_iOS_Beta-Swift.h"
#else
#import "MyEtherWallet_iOS-Swift.h"
#endif

#import "ResponseMappersFactory.h"
#import "ServiceComponentsAssembly.h"
#import "OperationFactoriesAssembly.h"
#import "SystemInfrastructureAssembly.h"
#import "PonsomizerAssembly.h"

#import "MEWConnectServiceImplementation.h"
#import "MEWRTCServiceImplementation.h"
#import "MEWcryptoImplementation.h"
#import "MEWWalletImplementation.h"
#import "MEWConnectFacadeImplementation.h"

#import "TokensServiceImplementation.h"
#import "CameraServiceImplementation.h"
#import "BlockchainNetworkServiceImplementation.h"
#import "AccountsServiceImplementation.h"
#import "KeychainServiceImplementation.h"
#import "FiatPricesServiceImplementation.h"
#import "SimplexServiceImplementation.h"

#import "OperationSchedulerImplementation.h"

static NSString *const kConfigFileName          = @"ServicesConfig.plist";

static NSString *const kSignallingServerURLKey  = @"API.SignallingServerURL";

@implementation ServiceComponentsAssembly

#pragma mark - MEW

- (id<MEWConnectFacade>) MEWConnectFacade {
  return [TyphoonDefinition withClass:[MEWConnectFacadeImplementation class]
                        configuration:^(TyphoonDefinition *definition) {
                          definition.scope = TyphoonScopeSingleton;
                          [definition injectProperty:@selector(connectService) with:[self MEWConnectService]];
                          [definition injectProperty:@selector(accountsService) with:[self accountsService]];
                          [definition injectProperty:@selector(ponsomizer) with:[self.ponsomizerAssembly ponsomizer]];
                          [definition injectProperty:@selector(application) with:[self.systemInfrastructureAssembly application]];
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
                          [definition injectProperty:@selector(delegate)
                                                with:[self MEWConnectFacade]];
                          [definition injectProperty:@selector(signallingServerURL)
                                                with:TyphoonConfig(kSignallingServerURLKey)];
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

- (id<MEWwallet>) MEWwallet {
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
                          [definition injectProperty:@selector(keychainService)
                                                with:[self keychainService]];
                        }];
}

- (id<MEWcrypto>) MEWcrypto {
  return [TyphoonDefinition withClass:[MEWcryptoImplementation class]];
}

#pragma mark - Ethereum


- (id<BlockchainNetworkService>) blockchainNetworkService {
  return [TyphoonDefinition withClass:[BlockchainNetworkServiceImplementation class]
                        configuration:^(TyphoonDefinition *definition) {
                        }];
}

- (id <AccountsService>) accountsService {
  return [TyphoonDefinition withClass:[AccountsServiceImplementation class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(accountsOperationFactory)
                                                with:[self.operationFactoriesAssembly accountsOperationFactory]];
                          [definition injectProperty:@selector(operationScheduler)
                                                with:[self operationScheduler]];
                          [definition injectProperty:@selector(MEWwallet)
                                                with:[self MEWwallet]];
                          [definition injectProperty:@selector(keychainService)
                                                with:[self keychainService]];
                        }];
}

- (id<TokensService>) tokensService {
  return [TyphoonDefinition withClass:[TokensServiceImplementation class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(tokensOperationFactory)
                                                with:[self.operationFactoriesAssembly tokensOperationFactory]];
                          [definition injectProperty:@selector(operationScheduler)
                                                with:[self operationScheduler]];
                        }];
}

- (id<FiatPricesService>) fiatPricesService {
  return [TyphoonDefinition withClass:[FiatPricesServiceImplementation class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(fiatPricesOperationFactory)
                                                with:[self.operationFactoriesAssembly fiatPricesOperationFactory]];
                          [definition injectProperty:@selector(operationScheduler)
                                                with:[self operationScheduler]];
                        }];
}

- (id<SimplexService>) simplexService {
  return [TyphoonDefinition withClass:[SimplexServiceImplementation class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(simplexOperationFactory)
                                                with:[self.operationFactoriesAssembly simplexOperationFactory]];
                          [definition injectProperty:@selector(operationScheduler)
                                                with:[self operationScheduler]];
                          [definition injectProperty:@selector(keychainService)
                                                with:[self keychainService]];
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

- (id<KeychainService>)keychainService {
  return [TyphoonDefinition withClass:[KeychainServiceImplementation class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(keychainStore) with:[self keychainStore]];
                          [definition injectProperty:@selector(dateFormatter) with:[self dateFormatter]];
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

- (UICKeyChainStore *) keychainStore {
  return [TyphoonDefinition withClass:[UICKeyChainStore class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition useInitializer:@selector(keyChainStoreWithService:)
                                          parameters:^(TyphoonMethod *initializer) {
                                            [initializer injectParameterWith:kKeychainService];
                                          }];
                        }];
}

- (NSDateFormatter *) dateFormatter {
  return [TyphoonDefinition withClass:[NSDateFormatter class]
                        configuration:^(TyphoonDefinition *definition) {
                          definition.scope = TyphoonScopeSingleton;
                          [definition injectMethod:@selector(setDateFormat:)
                                        parameters:^(TyphoonMethod *method) {
                                          [method injectParameterWith:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
                                        }];
                          [definition injectMethod:@selector(setTimeZone:)
                                        parameters:^(TyphoonMethod *method) {
                                          [method injectParameterWith:[NSTimeZone timeZoneForSecondsFromGMT:0]];
                                        }];
                        }];
}

#pragma mark - AVCapture

- (AVCaptureSession *) captureSession {
  return [TyphoonDefinition withClass:[AVCaptureSession class]];
}

- (AVCaptureMetadataOutput *) captureMetadataOutput {
  return [TyphoonDefinition withClass:[AVCaptureMetadataOutput class]];
}

#pragma mark - Config

- (id)configurer {
  return [TyphoonDefinition withConfigName:kConfigFileName];
}

@end
