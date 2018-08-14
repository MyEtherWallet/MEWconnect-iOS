//
//  BackupStartInteractorInput.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 23/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@class AccountPlainObject;

@protocol BackupStartInteractorInput <NSObject>
- (void) configurateWithAccount:(AccountPlainObject *)account;
- (void) passwordDidEntered:(NSString *)password;
- (AccountPlainObject *) obtainAccount;
@end
