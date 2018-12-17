//
//  RestoreSeedInteractorInput.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 04/11/2018.
//  Copyright © 2018 MyEtherWallet, Inc.. All rights reserved.
//

@import Foundation;

@class AccountPlainObject;

@protocol RestoreSeedInteractorInput <NSObject>
- (void) configureWithAccount:(AccountPlainObject *)account password:(NSString *)password;
- (void) checkMnemonics:(NSString *)mnemonics;
- (void) tryRestore;
@end
