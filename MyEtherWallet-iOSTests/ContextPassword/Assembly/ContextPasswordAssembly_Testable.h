//
//  ContextPasswordAssembly_Testable.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 11/09/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "ContextPasswordAssembly.h"

@class ContextPasswordViewController;
@class ContextPasswordInteractor;
@class ContextPasswordPresenter;
@class ContextPasswordRouter;

@interface ContextPasswordAssembly ()

- (ContextPasswordViewController *)viewContextPassword;
- (ContextPasswordPresenter *)presenterContextPassword;
- (ContextPasswordInteractor *)interactorContextPassword;
- (ContextPasswordRouter *)routerContextPassword;

@end
