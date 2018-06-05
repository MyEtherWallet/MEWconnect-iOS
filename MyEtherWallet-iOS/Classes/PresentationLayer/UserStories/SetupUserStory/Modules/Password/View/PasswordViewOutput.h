//
//  PasswordViewOutput.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@protocol PasswordViewOutput <NSObject>
- (void) didTriggerViewReadyEvent;
- (void) passwordDidChanged:(NSString *)password;
- (void) cancelAction;
- (void) nextAction;
@end
