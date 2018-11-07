//
//  BackupWordsInteractorInput.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 23/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@class AccountPlainObject;

@protocol BackupWordsInteractorInput <NSObject>
- (void) configurateWithMnemonics:(NSArray <NSString *> *)mnemonics ofAccount:(AccountPlainObject *)account;
- (NSArray <NSString *> *) recoveryMnemonicsWords;
- (AccountPlainObject *) obtainAccount;
- (void) subscribeToEvents;
- (void) unsubscribeFromEvents;
- (void) enableSecurityProtection;
- (void) disableSecurityProtection;
@end
