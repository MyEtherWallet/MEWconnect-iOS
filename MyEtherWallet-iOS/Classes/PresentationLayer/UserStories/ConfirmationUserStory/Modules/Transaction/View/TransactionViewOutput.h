//
//  TransactionViewOutput.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@protocol TransactionViewOutput <NSObject>
- (void) didTriggerViewReadyEvent;
- (void) signAction;
- (void) declineAction;
- (void) confirmAddressAction:(BOOL)confirmed;
- (void) confirmAmountAction:(BOOL)confirmed;
@end
