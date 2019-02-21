//
//  RestoreSafetyAssembly_Testable.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 18/02/2019.
//  Copyright © 2019 MyEtherWallet, Inc.. All rights reserved.
//

#import "RestoreSafetyAssembly.h"

@class RestoreSafetyViewController;
@class RestoreSafetyInteractor;
@class RestoreSafetyPresenter;
@class RestoreSafetyRouter;

@interface RestoreSafetyAssembly ()

- (RestoreSafetyViewController *)viewRestoreSafety;
- (RestoreSafetyPresenter *)presenterRestoreSafety;
- (RestoreSafetyInteractor *)interactorRestoreSafety;
- (RestoreSafetyRouter *)routerRestoreSafety;

@end
