//
//  RestoreWalletAssembly_Testable.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "RestoreWalletAssembly.h"

@class RestoreWalletViewController;
@class RestoreWalletInteractor;
@class RestoreWalletPresenter;
@class RestoreWalletRouter;

@interface RestoreWalletAssembly ()

- (RestoreWalletViewController *)viewRestoreWallet;
- (RestoreWalletPresenter *)presenterRestoreWallet;
- (RestoreWalletInteractor *)interactorRestoreWallet;
- (RestoreWalletRouter *)routerRestoreWallet;

@end
