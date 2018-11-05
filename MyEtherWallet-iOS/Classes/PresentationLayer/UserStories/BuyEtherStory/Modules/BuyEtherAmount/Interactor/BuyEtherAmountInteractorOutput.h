//
//  BuyEtherAmountInteractorOutput.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 02/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@class SimplexOrder;
@class MasterTokenPlainObject;

@protocol BuyEtherAmountInteractorOutput <NSObject>
- (void) updateInputPriceWithEnteredAmount:(NSString *)enteredAmount convertedAmount:(NSDecimalNumber *)convertedAmount;
- (void) orderDidCreated:(SimplexOrder *)order forMasterToken:(MasterTokenPlainObject *)masterToken;
- (void) minimumAmountDidReached:(BOOL)minimumAmountReached;
- (void) loadingDidStart;
- (void) loadingDidEnd;
@end
