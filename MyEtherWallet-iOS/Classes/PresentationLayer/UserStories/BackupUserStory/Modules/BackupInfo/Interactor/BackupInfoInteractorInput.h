//
//  BackupInfoInteractorInput.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 23/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@class AccountPlainObject;

@protocol BackupInfoInteractorInput <NSObject>
- (void) configurateWithAccount:(AccountPlainObject *)account;
- (AccountPlainObject *) obtainAccount;
@end
