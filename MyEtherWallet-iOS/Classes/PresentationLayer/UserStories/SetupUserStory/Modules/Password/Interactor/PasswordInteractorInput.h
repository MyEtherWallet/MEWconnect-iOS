//
//  PasswordInteractorInput.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@protocol PasswordInteractorInput <NSObject>
- (void) configureWithWords:(NSArray <NSString *> *)words;
- (void) scorePassword:(NSString *)password;
- (void) confirmPassword;
- (BOOL) isWordsProvided;
@end
