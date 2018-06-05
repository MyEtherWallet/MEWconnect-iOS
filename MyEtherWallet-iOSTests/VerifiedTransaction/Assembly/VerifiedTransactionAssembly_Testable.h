//
//  VerifiedTransactionAssembly_Testable.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "VerifiedTransactionAssembly.h"

@class VerifiedTransactionViewController;
@class VerifiedTransactionInteractor;
@class VerifiedTransactionPresenter;
@class VerifiedTransactionRouter;

@interface VerifiedTransactionAssembly ()

- (VerifiedTransactionViewController *)viewVerifiedTransaction;
- (VerifiedTransactionPresenter *)presenterVerifiedTransaction;
- (VerifiedTransactionInteractor *)interactorVerifiedTransaction;
- (VerifiedTransactionRouter *)routerVerifiedTransaction;

@end
