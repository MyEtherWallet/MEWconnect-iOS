//
//  HomeAssembly_Testable.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "HomeAssembly.h"

@class HomeViewController;
@class HomeInteractor;
@class HomePresenter;
@class HomeRouter;

@interface HomeAssembly ()

- (HomeViewController *)viewHome;
- (HomePresenter *)presenterHome;
- (HomeInteractor *)interactorHome;
- (HomeRouter *)routerHome;

@end
