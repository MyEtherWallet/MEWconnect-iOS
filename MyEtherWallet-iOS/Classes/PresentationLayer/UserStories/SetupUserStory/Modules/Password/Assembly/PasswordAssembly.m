//
//  PasswordAssembly.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import ViperMcFlurryX;
@import zxcvbn_ios.DBZxcvbn;

#import "PasswordAssembly.h"

#import "PasswordViewController.h"
#import "PasswordInteractor.h"
#import "PasswordPresenter.h"
#import "PasswordRouter.h"

@implementation PasswordAssembly

- (PasswordViewController *)viewPassword {
  return [TyphoonDefinition withClass:[PasswordViewController class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(output)
                                                with:[self presenterPassword]];
                          [definition injectProperty:@selector(moduleInput)
                                                with:[self presenterPassword]];
                        }];
}

- (PasswordInteractor *)interactorPassword {
  return [TyphoonDefinition withClass:[PasswordInteractor class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(output)
                                                with:[self presenterPassword]];
                          [definition injectProperty:@selector(zxcvbn)
                                                with:[self dbzxcvbn]];
                        }];
}

- (PasswordPresenter *)presenterPassword{
  return [TyphoonDefinition withClass:[PasswordPresenter class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(view)
                                                with:[self viewPassword]];
                          [definition injectProperty:@selector(interactor)
                                                with:[self interactorPassword]];
                          [definition injectProperty:@selector(router)
                                                with:[self routerPassword]];
                        }];
}

- (PasswordRouter *)routerPassword{
  return [TyphoonDefinition withClass:[PasswordRouter class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(transitionHandler)
                                                with:[self viewPassword]];
                        }];
}

- (DBZxcvbn *) dbzxcvbn {
  return [TyphoonDefinition withClass:[DBZxcvbn class]];
}

@end
