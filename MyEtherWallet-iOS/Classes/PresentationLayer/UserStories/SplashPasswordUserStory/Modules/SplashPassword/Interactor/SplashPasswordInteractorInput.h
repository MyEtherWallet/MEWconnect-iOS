//
//  SplashPasswordInteractorInput.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 26/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@class AccountPlainObject;

@protocol SplashPasswordInteractorInput <NSObject>
- (void) configurateWithAccount:(AccountPlainObject *)account;
- (AccountPlainObject *) obtainAccount;
- (void) checkPassword:(NSString *)password;
@end
