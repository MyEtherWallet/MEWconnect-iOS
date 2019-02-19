//
//  RestoreOptionsViewOutput.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 18/02/2019.
//  Copyright © 2019 MyEtherWallet, Inc.. All rights reserved.
//

@import Foundation;

@protocol RestoreOptionsViewOutput <NSObject>
- (void) didTriggerViewReadyEvent;
- (void) closeAction;
- (void) otherOptionsAction;
- (void) recoveryPhraseAction;
@end
