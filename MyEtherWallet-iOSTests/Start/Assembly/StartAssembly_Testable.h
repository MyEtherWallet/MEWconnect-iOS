//
//  StartAssembly_Testable.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 14/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "StartAssembly.h"

@class StartViewController;
@class StartInteractor;
@class StartPresenter;
@class StartRouter;

@interface StartAssembly ()

- (StartViewController *)viewStart;
- (StartPresenter *)presenterStart;
- (StartInteractor *)interactorStart;
- (StartRouter *)routerStart;

@end
