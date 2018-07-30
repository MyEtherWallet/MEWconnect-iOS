//
//  ConfirmationNavigationAssembly_Testable.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 17/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "ConfirmationNavigationAssembly.h"

@class ConfirmationNavigationViewController;
@class ConfirmationNavigationInteractor;
@class ConfirmationNavigationPresenter;
@class ConfirmationNavigationRouter;

@interface ConfirmationNavigationAssembly ()

- (ConfirmationNavigationViewController *)viewConfirmationNavigation;
- (ConfirmationNavigationPresenter *)presenterConfirmationNavigation;
- (ConfirmationNavigationInteractor *)interactorConfirmationNavigation;
- (ConfirmationNavigationRouter *)routerConfirmationNavigation;

@end
