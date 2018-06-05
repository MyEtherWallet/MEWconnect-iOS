//
//  ConfirmedTransactionAssembly_Testable.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 19/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "ConfirmedTransactionAssembly.h"

@class ConfirmedTransactionViewController;
@class ConfirmedTransactionInteractor;
@class ConfirmedTransactionPresenter;
@class ConfirmedTransactionRouter;

@interface ConfirmedTransactionAssembly ()

- (ConfirmedTransactionViewController *)viewConfirmedTransaction;
- (ConfirmedTransactionPresenter *)presenterConfirmedTransaction;
- (ConfirmedTransactionInteractor *)interactorConfirmedTransaction;
- (ConfirmedTransactionRouter *)routerConfirmedTransaction;

@end
