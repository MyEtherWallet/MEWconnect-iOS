//
//  ForgotPasswordAssembly_Testable.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 27/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "ForgotPasswordAssembly.h"

@class ForgotPasswordViewController;
@class ForgotPasswordInteractor;
@class ForgotPasswordPresenter;
@class ForgotPasswordRouter;

@interface ForgotPasswordAssembly ()

- (ForgotPasswordViewController *)viewForgotPassword;
- (ForgotPasswordPresenter *)presenterForgotPassword;
- (ForgotPasswordInteractor *)interactorForgotPassword;
- (ForgotPasswordRouter *)routerForgotPassword;

@end
