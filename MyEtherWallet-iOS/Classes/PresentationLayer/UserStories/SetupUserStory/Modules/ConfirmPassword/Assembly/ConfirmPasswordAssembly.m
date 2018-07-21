//
//  ConfirmPasswordAssembly.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 01/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import ViperMcFlurryX;

#import "ConfirmPasswordAssembly.h"

#import "ConfirmPasswordViewController.h"
#import "ConfirmPasswordInteractor.h"
#import "ConfirmPasswordPresenter.h"
#import "ConfirmPasswordRouter.h"

@implementation ConfirmPasswordAssembly

- (ConfirmPasswordViewController *)viewConfirmPassword {
    return [TyphoonDefinition withClass:[ConfirmPasswordViewController class]
                          configuration:^(TyphoonDefinition *definition) {
                              [definition injectProperty:@selector(output)
                                                    with:[self presenterConfirmPassword]];
                              [definition injectProperty:@selector(moduleInput)
                                                    with:[self presenterConfirmPassword]];
                          }];
}

- (ConfirmPasswordInteractor *)interactorConfirmPassword {
    return [TyphoonDefinition withClass:[ConfirmPasswordInteractor class]
                          configuration:^(TyphoonDefinition *definition) {
                              [definition injectProperty:@selector(output)
                                                    with:[self presenterConfirmPassword]];
                          }];
}

- (ConfirmPasswordPresenter *)presenterConfirmPassword{
    return [TyphoonDefinition withClass:[ConfirmPasswordPresenter class]
                          configuration:^(TyphoonDefinition *definition) {
                              [definition injectProperty:@selector(view)
                                                    with:[self viewConfirmPassword]];
                              [definition injectProperty:@selector(interactor)
                                                    with:[self interactorConfirmPassword]];
                              [definition injectProperty:@selector(router)
                                                    with:[self routerConfirmPassword]];
                          }];
}

- (ConfirmPasswordRouter *)routerConfirmPassword{
    return [TyphoonDefinition withClass:[ConfirmPasswordRouter class]
                          configuration:^(TyphoonDefinition *definition) {
                              [definition injectProperty:@selector(transitionHandler)
                                                    with:[self viewConfirmPassword]];
                          }];
}

@end
