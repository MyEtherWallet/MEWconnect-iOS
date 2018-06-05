//
//  ConfirmPasswordAssembly_Testable.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 01/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "ConfirmPasswordAssembly.h"

@class ConfirmPasswordViewController;
@class ConfirmPasswordInteractor;
@class ConfirmPasswordPresenter;
@class ConfirmPasswordRouter;

@interface ConfirmPasswordAssembly ()

- (ConfirmPasswordViewController *)viewConfirmPassword;
- (ConfirmPasswordPresenter *)presenterConfirmPassword;
- (ConfirmPasswordInteractor *)interactorConfirmPassword;
- (ConfirmPasswordRouter *)routerConfirmPassword;

@end
