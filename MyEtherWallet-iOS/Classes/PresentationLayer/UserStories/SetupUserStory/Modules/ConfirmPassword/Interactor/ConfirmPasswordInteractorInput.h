//
//  ConfirmPasswordInteractorInput.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 01/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@protocol ConfirmPasswordInteractorInput <NSObject>
- (void) configurateWithPassword:(NSString *)password words:(NSArray <NSString *> *)words;
- (void) complareConfirmationPassword:(NSString *)password;
- (void) confirmPasswordWithPassword:(NSString *)password;
@end
