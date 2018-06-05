//
//  BackupWordsViewOutput.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 23/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@protocol BackupWordsViewOutput <NSObject>
- (void) didTriggerViewReadyEvent;
- (void) nextAction;
- (void) didTriggerViewWillAppearEvent;
- (void) didTriggerViewWillDisappearEvent;
@end
