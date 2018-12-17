//
//  ShareAssembly_Testable.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 11/10/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "ShareAssembly.h"

@class ShareViewController;
@class ShareInteractor;
@class SharePresenter;
@class ShareRouter;

@interface ShareAssembly ()

- (ShareViewController *)viewShare;
- (SharePresenter *)presenterShare;
- (ShareInteractor *)interactorShare;
- (ShareRouter *)routerShare;

@end
