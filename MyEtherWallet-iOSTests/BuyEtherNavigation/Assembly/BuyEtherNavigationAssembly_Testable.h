//
//  BuyEtherNavigationAssembly_Testable.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 03/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "BuyEtherNavigationAssembly.h"

@class BuyEtherNavigationController;
@class BuyEtherNavigationInteractor;
@class BuyEtherNavigationPresenter;
@class BuyEtherNavigationRouter;

@interface BuyEtherNavigationAssembly ()

- (BuyEtherNavigationController *)viewBuyEtherNavigation;
- (BuyEtherNavigationPresenter *)presenterBuyEtherNavigation;
- (BuyEtherNavigationInteractor *)interactorBuyEtherNavigation;
- (BuyEtherNavigationRouter *)routerBuyEtherNavigation;

@end
