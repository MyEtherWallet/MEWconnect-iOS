//
//  BuyEtherAmountInteractorInput.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 02/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

#import "BlockchainNetworkTypes.h"
#import "SimplexServiceCurrencyTypes.h"

@class AccountPlainObject;

@protocol BuyEtherAmountInteractorInput <NSObject>
- (void) configurateWithAccount:(AccountPlainObject *)account;
- (void) appendSymbol:(NSString *)symbol;
- (void) eraseSymbol;
- (void) switchConverting;
- (SimplexServiceCurrencyType) obtainCurrencyType;
- (NSString *) obtainEnteredAmount;
- (NSDecimalNumber *) obtainConvertedAmount;
- (void) prepareQuote;
- (AccountPlainObject *) obtainAccount;
- (NSDecimalNumber *) obtainMinimumAmount;
@end
