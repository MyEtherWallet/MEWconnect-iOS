//
//  ContextPasswordAssembly.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 11/09/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import ViperMcFlurryX;

#import "TransitioningDelegateFactory.h"
#import "ServiceComponents.h"
#import "PonsomizerAssembly.h"

#import "ContextPasswordAssembly.h"

#import "ContextPasswordViewController.h"
#import "ContextPasswordInteractor.h"
#import "ContextPasswordPresenter.h"
#import "ContextPasswordRouter.h"

@implementation ContextPasswordAssembly

- (ContextPasswordViewController *)viewContextPassword {
  return [TyphoonDefinition withClass:[ContextPasswordViewController class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(output)
                                                with:[self presenterContextPassword]];
                          [definition injectProperty:@selector(moduleInput)
                                                with:[self presenterContextPassword]];
                          [definition injectProperty:@selector(customTransitioningDelegate)
                                                with:[self.transitioningDelegateFactory transitioningDelegateWithType:@(TransitioningDelegateFadeModal) cornerRadius:@16.0]];
                          [definition injectProperty:@selector(modalPresentationStyle)
                                                with:@(UIModalPresentationCustom)];
                        }];
}

- (ContextPasswordInteractor *)interactorContextPassword {
  return [TyphoonDefinition withClass:[ContextPasswordInteractor class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(output)
                                                with:[self presenterContextPassword]];
                          [definition injectProperty:@selector(accountsService)
                                                with:[self.serviceComponents accountsService]];
                          [definition injectProperty:@selector(walletService)
                                                with:[self.serviceComponents MEWwallet]];
                          [definition injectProperty:@selector(ponsomizer)
                                                with:[self.ponsomizerAssembly ponsomizer]];
                        }];
}

- (ContextPasswordPresenter *)presenterContextPassword{
  return [TyphoonDefinition withClass:[ContextPasswordPresenter class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(view)
                                                with:[self viewContextPassword]];
                          [definition injectProperty:@selector(interactor)
                                                with:[self interactorContextPassword]];
                          [definition injectProperty:@selector(router)
                                                with:[self routerContextPassword]];
                        }];
}

- (ContextPasswordRouter *)routerContextPassword{
  return [TyphoonDefinition withClass:[ContextPasswordRouter class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(transitionHandler)
                                                with:[self viewContextPassword]];
                        }];
}

@end
