//
//  NewWalletAssembly_Testable.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "NewWalletAssembly.h"

@class NewWalletViewController;
@class NewWalletInteractor;
@class NewWalletPresenter;
@class NewWalletRouter;

@interface NewWalletAssembly ()

- (NewWalletViewController *)viewNewWallet;
- (NewWalletPresenter *)presenterNewWallet;
- (NewWalletInteractor *)interactorNewWallet;
- (NewWalletRouter *)routerNewWallet;

@end
