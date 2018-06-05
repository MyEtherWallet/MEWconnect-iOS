//
//  PasswordAssembly_Testable.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "PasswordAssembly.h"

@class PasswordViewController;
@class PasswordInteractor;
@class PasswordPresenter;
@class PasswordRouter;

@interface PasswordAssembly ()

- (PasswordViewController *)viewPassword;
- (PasswordPresenter *)presenterPassword;
- (PasswordInteractor *)interactorPassword;
- (PasswordRouter *)routerPassword;

@end
