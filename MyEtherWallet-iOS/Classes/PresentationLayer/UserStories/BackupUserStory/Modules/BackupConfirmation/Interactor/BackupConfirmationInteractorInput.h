//
//  BackupConfirmationInteractorInput.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 23/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@class BackupConfirmationQuiz;

@protocol BackupConfirmationInteractorInput <NSObject>
- (void) configurateWithMnemonics:(NSArray <NSString *> *)mnemonics;
- (BackupConfirmationQuiz *) obtainRecoveryQuiz;
- (void) checkVector:(NSArray <NSString *> *)vector;
- (void) walletBackedUp;
@end
