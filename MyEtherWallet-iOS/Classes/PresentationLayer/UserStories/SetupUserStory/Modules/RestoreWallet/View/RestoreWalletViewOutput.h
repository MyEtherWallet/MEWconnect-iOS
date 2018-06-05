//
//  RestoreWalletViewOutput.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@protocol RestoreWalletViewOutput <NSObject>
- (void) didTriggerViewReadyEvent;
- (void) cancelAction;
- (void) nextAction;
- (void) textDidChangedAction:(NSString *)text;
@end
