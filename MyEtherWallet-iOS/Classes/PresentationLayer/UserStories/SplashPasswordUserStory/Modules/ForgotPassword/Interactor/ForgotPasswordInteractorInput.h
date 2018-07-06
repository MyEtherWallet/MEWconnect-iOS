//
//  ForgotPasswordInteractorInput.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 27/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@class AccountPlainObject;

@protocol ForgotPasswordInteractorInput <NSObject>
- (void) configurateWithAccount:(AccountPlainObject *)account;
- (void) resetWallet;
@end
