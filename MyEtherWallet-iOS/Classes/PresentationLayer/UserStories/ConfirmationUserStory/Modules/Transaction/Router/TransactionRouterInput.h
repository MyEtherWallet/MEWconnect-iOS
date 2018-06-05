//
//  TransactionRouterInput.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@protocol SplashPasswordModuleOutput;

@protocol TransactionRouterInput <NSObject>
- (void) openConfirmedTransaction;
- (void) openDeclinedTransaction;
- (void) close;
- (void) openSplashPasswordWithOutput:(id <SplashPasswordModuleOutput>)output;
@end
