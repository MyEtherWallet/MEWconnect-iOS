//
//  PasswordRouterInput.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@protocol PasswordRouterInput <NSObject>
- (void) openConfirmationWithPassword:(NSString *)password words:(NSArray <NSString *> *)words forgotPassword:(BOOL)forgotPassword;
- (void) close;
@end
