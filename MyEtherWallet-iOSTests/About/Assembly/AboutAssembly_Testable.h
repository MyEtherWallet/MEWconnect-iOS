//
//  AboutAssembly_Testable.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 25/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "AboutAssembly.h"

@class AboutViewController;
@class AboutInteractor;
@class AboutPresenter;
@class AboutRouter;

@interface AboutAssembly ()

- (AboutViewController *)viewAbout;
- (AboutPresenter *)presenterAbout;
- (AboutInteractor *)interactorAbout;
- (AboutRouter *)routerAbout;

@end
