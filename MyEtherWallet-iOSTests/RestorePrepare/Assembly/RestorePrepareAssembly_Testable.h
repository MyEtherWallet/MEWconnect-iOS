//
//  RestorePrepareAssembly_Testable.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 18/02/2019.
//  Copyright © 2019 MyEtherWallet, Inc.. All rights reserved.
//

#import "RestorePrepareAssembly.h"

@class RestorePrepareViewController;
@class RestorePrepareInteractor;
@class RestorePreparePresenter;
@class RestorePrepareRouter;

@interface RestorePrepareAssembly ()

- (RestorePrepareViewController *)viewRestorePrepare;
- (RestorePreparePresenter *)presenterRestorePrepare;
- (RestorePrepareInteractor *)interactorRestorePrepare;
- (RestorePrepareRouter *)routerRestorePrepare;

@end
