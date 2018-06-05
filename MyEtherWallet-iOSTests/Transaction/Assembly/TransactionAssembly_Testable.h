//
//  TransactionAssembly_Testable.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "TransactionAssembly.h"

@class TransactionViewController;
@class TransactionInteractor;
@class TransactionPresenter;
@class TransactionRouter;

@interface TransactionAssembly ()

- (TransactionViewController *)viewTransaction;
- (TransactionPresenter *)presenterTransaction;
- (TransactionInteractor *)interactorTransaction;
- (TransactionRouter *)routerTransaction;

@end
