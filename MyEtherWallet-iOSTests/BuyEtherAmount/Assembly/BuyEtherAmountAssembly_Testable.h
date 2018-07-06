//
//  BuyEtherAmountAssembly_Testable.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 02/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "BuyEtherAmountAssembly.h"

@class BuyEtherAmountViewController;
@class BuyEtherAmountInteractor;
@class BuyEtherAmountPresenter;
@class BuyEtherAmountRouter;

@interface BuyEtherAmountAssembly ()

- (BuyEtherAmountViewController *)viewBuyEtherAmount;
- (BuyEtherAmountPresenter *)presenterBuyEtherAmount;
- (BuyEtherAmountInteractor *)interactorBuyEtherAmount;
- (BuyEtherAmountRouter *)routerBuyEtherAmount;

@end
