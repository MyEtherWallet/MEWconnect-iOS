//
//  SplashPasswordViewOutput.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 26/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@protocol SplashPasswordViewOutput <NSObject>
- (void) didTriggerViewReadyEvent;
- (void) doneActionWithPassword:(NSString *)password;
- (void) forgotPasswordAction;
@end
