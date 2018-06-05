//
//  DeclinedTransactionAssembly_Testable.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "DeclinedTransactionAssembly.h"

@class DeclinedTransactionViewController;
@class DeclinedTransactionInteractor;
@class DeclinedTransactionPresenter;
@class DeclinedTransactionRouter;

@interface DeclinedTransactionAssembly ()

- (DeclinedTransactionViewController *)viewDeclinedTransaction;
- (DeclinedTransactionPresenter *)presenterDeclinedTransaction;
- (DeclinedTransactionInteractor *)interactorDeclinedTransaction;
- (DeclinedTransactionRouter *)routerDeclinedTransaction;

@end
