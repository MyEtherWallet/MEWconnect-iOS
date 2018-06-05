//
//  BackupInfoViewOutput.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 23/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@protocol BackupInfoViewOutput <NSObject>
- (void) didTriggerViewReadyEvent;
- (void) startAction;
- (void) cancelAction;
@end
