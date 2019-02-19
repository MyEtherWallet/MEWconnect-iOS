//
//  RestoreOptionsAssembly_Testable.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 18/02/2019.
//  Copyright © 2019 MyEtherWallet, Inc.. All rights reserved.
//

#import "RestoreOptionsAssembly.h"

@class RestoreOptionsViewController;
@class RestoreOptionsInteractor;
@class RestoreOptionsPresenter;
@class RestoreOptionsRouter;

@interface RestoreOptionsAssembly ()

- (RestoreOptionsViewController *)viewRestoreOptions;
- (RestoreOptionsPresenter *)presenterRestoreOptions;
- (RestoreOptionsInteractor *)interactorRestoreOptions;
- (RestoreOptionsRouter *)routerRestoreOptions;

@end
