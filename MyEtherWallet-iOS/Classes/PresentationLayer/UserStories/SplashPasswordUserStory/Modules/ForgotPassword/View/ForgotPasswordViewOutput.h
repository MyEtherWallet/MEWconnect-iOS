//
//  ForgotPasswordViewOutput.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 27/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@protocol ForgotPasswordViewOutput <NSObject>
- (void) didTriggerViewReadyEvent;
- (void) restoreAction;
- (void) closeAction;
- (void) resetWalletAction;
- (void) resetWalletConfirmedAction;
@end
