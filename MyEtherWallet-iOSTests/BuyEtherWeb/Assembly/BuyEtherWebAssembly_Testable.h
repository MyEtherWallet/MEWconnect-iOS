//
//  BuyEtherWebAssembly_Testable.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 05/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "BuyEtherWebAssembly.h"

@class BuyEtherWebViewController;
@class BuyEtherWebInteractor;
@class BuyEtherWebPresenter;
@class BuyEtherWebRouter;

@interface BuyEtherWebAssembly ()

- (BuyEtherWebViewController *)viewBuyEtherWeb;
- (BuyEtherWebPresenter *)presenterBuyEtherWeb;
- (BuyEtherWebInteractor *)interactorBuyEtherWeb;
- (BuyEtherWebRouter *)routerBuyEtherWeb;

@end
