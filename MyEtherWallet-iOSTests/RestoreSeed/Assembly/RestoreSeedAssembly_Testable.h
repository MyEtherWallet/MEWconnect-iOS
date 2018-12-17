//
//  RestoreSeedAssembly_Testable.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 04/11/2018.
//  Copyright © 2018 MyEtherWallet, Inc.. All rights reserved.
//

#import "RestoreSeedAssembly.h"

@class RestoreSeedViewController;
@class RestoreSeedInteractor;
@class RestoreSeedPresenter;
@class RestoreSeedRouter;

@interface RestoreSeedAssembly ()

- (RestoreSeedViewController *)viewRestoreSeed;
- (RestoreSeedPresenter *)presenterRestoreSeed;
- (RestoreSeedInteractor *)interactorRestoreSeed;
- (RestoreSeedRouter *)routerRestoreSeed;

@end
