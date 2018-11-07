//
//  ContextPasswordViewOutput.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 11/09/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@protocol ContextPasswordViewOutput <NSObject>
- (void) didTriggerViewReadyEvent;
- (void) cancelAction;
- (void) resignAction;
- (void) doneActionWithPassword:(NSString *)password;
@end
