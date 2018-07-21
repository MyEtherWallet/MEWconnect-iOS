//
//  QRScannerAssembly.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import ViperMcFlurryX;

#import "ServiceComponentsAssembly.h"

#import "TransitioningDelegateFactory.h"

#import "QRScannerAssembly.h"

#import "QRScannerViewController.h"
#import "QRScannerInteractor.h"
#import "QRScannerPresenter.h"
#import "QRScannerRouter.h"

@implementation QRScannerAssembly

- (QRScannerViewController *)viewQRScanner {
  return [TyphoonDefinition withClass:[QRScannerViewController class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(output)
                                                with:[self presenterQRScanner]];
                          [definition injectProperty:@selector(moduleInput)
                                                with:[self presenterQRScanner]];
                          [definition injectProperty:@selector(customTransitioningDelegate)
                                                with:[self.transitioningDelegateFactory transitioningDelegateWithType:@(TransitioningDelegateBottomModal) cornerRadius:@8.0]];
                          [definition injectProperty:@selector(modalPresentationStyle)
                                                with:@(UIModalPresentationCustom)];
                        }];
}

- (QRScannerInteractor *)interactorQRScanner {
  return [TyphoonDefinition withClass:[QRScannerInteractor class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(output)
                                                with:[self presenterQRScanner]];
                          [definition injectProperty:@selector(connectFacade)
                                                with:[self.serviceComponents MEWConnectFacade]];
                          [definition injectProperty:@selector(cameraService)
                                                with:[self.serviceComponents cameraServiceWithDelegate:[self interactorQRScanner]]];
                        }];
}

- (QRScannerPresenter *)presenterQRScanner{
  return [TyphoonDefinition withClass:[QRScannerPresenter class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(view)
                                                with:[self viewQRScanner]];
                          [definition injectProperty:@selector(interactor)
                                                with:[self interactorQRScanner]];
                          [definition injectProperty:@selector(router)
                                                with:[self routerQRScanner]];
                        }];
}

- (QRScannerRouter *)routerQRScanner{
  return [TyphoonDefinition withClass:[QRScannerRouter class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(transitionHandler)
                                                with:[self viewQRScanner]];
                        }];
}

@end
