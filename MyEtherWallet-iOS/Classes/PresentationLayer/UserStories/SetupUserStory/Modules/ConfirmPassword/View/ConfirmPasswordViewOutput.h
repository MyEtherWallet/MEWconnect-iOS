//
//  ConfirmPasswordViewOutput.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 01/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@protocol ConfirmPasswordViewOutput <NSObject>
- (void) didTriggerViewReadyEvent;
- (void) passwordDidChanged:(NSString *)password;
- (void) nextActionWithPassword:(NSString *)password;
@end
