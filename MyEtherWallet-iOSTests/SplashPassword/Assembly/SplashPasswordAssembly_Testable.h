//
//  SplashPasswordAssembly_Testable.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 26/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "SplashPasswordAssembly.h"

@class SplashPasswordViewController;
@class SplashPasswordInteractor;
@class SplashPasswordPresenter;
@class SplashPasswordRouter;

@interface SplashPasswordAssembly ()

- (SplashPasswordViewController *)viewSplashPassword;
- (SplashPasswordPresenter *)presenterSplashPassword;
- (SplashPasswordInteractor *)interactorSplashPassword;
- (SplashPasswordRouter *)routerSplashPassword;

@end
