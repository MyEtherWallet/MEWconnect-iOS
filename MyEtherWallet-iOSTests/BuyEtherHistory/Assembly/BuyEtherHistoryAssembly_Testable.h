//
//  BuyEtherHistoryAssembly_Testable.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 02/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "BuyEtherHistoryAssembly.h"

@class BuyEtherHistoryViewController;
@class BuyEtherHistoryInteractor;
@class BuyEtherHistoryPresenter;
@class BuyEtherHistoryRouter;

@interface BuyEtherHistoryAssembly ()

- (BuyEtherHistoryViewController *)viewBuyEtherHistory;
- (BuyEtherHistoryPresenter *)presenterBuyEtherHistory;
- (BuyEtherHistoryInteractor *)interactorBuyEtherHistory;
- (BuyEtherHistoryRouter *)routerBuyEtherHistory;

@end
