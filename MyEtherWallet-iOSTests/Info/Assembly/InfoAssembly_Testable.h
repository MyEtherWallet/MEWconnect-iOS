//
//  InfoAssembly_Testable.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 24/06/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "InfoAssembly.h"

@class InfoViewController;
@class InfoInteractor;
@class InfoPresenter;
@class InfoRouter;

@interface InfoAssembly ()

- (InfoViewController *)viewInfo;
- (InfoPresenter *)presenterInfo;
- (InfoInteractor *)interactorInfo;
- (InfoRouter *)routerInfo;

@end
