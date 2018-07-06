//
//  BuyEtherAmountViewOutput.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 02/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@protocol BuyEtherAmountViewOutput <NSObject>
- (void) didTriggerViewReadyEvent;
- (void) didEnterSymbolAction:(NSString *)symbol;
- (void) eraseSymbolAction;
- (void) closeAction;
- (void) historyAction;
- (void) buyAction;
- (void) switchConvertingAction;
@end
