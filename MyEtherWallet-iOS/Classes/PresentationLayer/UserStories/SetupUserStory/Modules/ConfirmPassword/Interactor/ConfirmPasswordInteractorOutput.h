//
//  ConfirmPasswordInteractorOutput.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 01/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@protocol ConfirmPasswordInteractorOutput <NSObject>
- (void) emptyConfirmationPassword;
- (void) correctPasswords;
- (void) incorrectPassword:(BOOL)error;
- (void) prepareWalletWithPassword:(NSString *)password words:(NSArray <NSString *> *)words;
@end
