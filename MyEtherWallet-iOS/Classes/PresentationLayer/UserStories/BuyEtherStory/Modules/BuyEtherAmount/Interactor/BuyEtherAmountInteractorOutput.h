//
//  BuyEtherAmountInteractorOutput.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 02/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@class SimplexOrder;
@class AccountPlainObject;

@protocol BuyEtherAmountInteractorOutput <NSObject>
- (void) updateInputPriceWithEnteredAmount:(NSString *)enteredAmount convertedAmount:(NSDecimalNumber *)convertedAmount;
- (void) orderDidCreated:(SimplexOrder *)order forAccount:(AccountPlainObject *)account;
- (void) minimumAmountDidReached:(BOOL)minimumAmountReached;
@end
