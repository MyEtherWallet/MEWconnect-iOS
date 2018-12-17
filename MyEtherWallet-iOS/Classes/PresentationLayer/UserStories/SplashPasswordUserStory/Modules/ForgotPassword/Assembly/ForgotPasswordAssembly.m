//
//  ForgotPasswordAssembly.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 27/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import ViperMcFlurryX;

#import "TransitioningDelegateFactory.h"
#import "ServiceComponents.h"

#import "ForgotPasswordAssembly.h"

#import "ForgotPasswordViewController.h"
#import "ForgotPasswordInteractor.h"
#import "ForgotPasswordPresenter.h"
#import "ForgotPasswordRouter.h"

@implementation ForgotPasswordAssembly

- (ForgotPasswordViewController *)viewForgotPassword {
  return [TyphoonDefinition withClass:[ForgotPasswordViewController class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(output)
                                                with:[self presenterForgotPassword]];
                          [definition injectProperty:@selector(moduleInput)
                                                with:[self presenterForgotPassword]];
                          [definition injectProperty:@selector(customTransitioningDelegate)
                                                with:[self.transitioningDelegateFactory transitioningDelegateWithType:@(TransitioningDelegateBottomModal) cornerRadius:@16.0]];
                          [definition injectProperty:@selector(modalPresentationStyle)
                                                with:@(UIModalPresentationCustom)];
                        }];
}

- (ForgotPasswordInteractor *)interactorForgotPassword {
  return [TyphoonDefinition withClass:[ForgotPasswordInteractor class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(output)
                                                with:[self presenterForgotPassword]];
                          [definition injectProperty:@selector(accountsService)
                                                with:[self.serviceComponents accountsService]];
                          [definition injectProperty:@selector(keychainService)
                                                with:[self.serviceComponents keychainService]];
                        }];
}

- (ForgotPasswordPresenter *)presenterForgotPassword{
  return [TyphoonDefinition withClass:[ForgotPasswordPresenter class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(view)
                                                with:[self viewForgotPassword]];
                          [definition injectProperty:@selector(interactor)
                                                with:[self interactorForgotPassword]];
                          [definition injectProperty:@selector(router)
                                                with:[self routerForgotPassword]];
                        }];
}

- (ForgotPasswordRouter *)routerForgotPassword{
  return [TyphoonDefinition withClass:[ForgotPasswordRouter class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(transitionHandler)
                                                with:[self viewForgotPassword]];
                        }];
}

@end
