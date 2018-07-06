//
//  BackupStartRouterInput.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 23/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@protocol SplashPasswordModuleOutput;
@class AccountPlainObject;

@protocol BackupStartRouterInput <NSObject>
- (void) openSplashPasswordWithOutput:(id <SplashPasswordModuleOutput>)output account:(AccountPlainObject *)account;
- (void) openWordsWithMnemonics:(NSArray <NSString *> *)mnemonics account:(AccountPlainObject *)account;
@end
