//
//  BuyEtherAmountViewInput.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 02/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

#import "BlockchainNetworkTypes.h"
#import "SimplexServiceCurrencyTypes.h"

@protocol BuyEtherAmountViewInput <NSObject>
- (void) setupInitialStateWithCurrency:(SimplexServiceCurrencyType)currency minimumAmount:(NSDecimalNumber *)minimumAmount;
- (void) updateWithEnteredAmount:(NSString *)enteredAmount convertedAmount:(NSDecimalNumber *)convertedAmount;
- (void) updateCurrency:(SimplexServiceCurrencyType)currency;
- (void) enableContinue;
- (void) disableContinue;
- (void) showLoading;
- (void) hideLoading;
@end
