//
//  BackupConfirmationViewOutput.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 23/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@protocol BackupConfirmationViewOutput <NSObject>
- (void) didTriggerViewReadyEvent;
- (void) didSelectAnswers:(NSArray <NSString *>*)vector;
- (void) finishAction;
- (void) didTriggerViewWillAppearEvent;
- (void) didTriggerViewWillDisappearEvent;
@end
