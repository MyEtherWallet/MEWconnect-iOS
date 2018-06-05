//
//  ConfirmPasswordRouterInput.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 01/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@protocol ConfirmPasswordRouterInput <NSObject>
- (void) openNewWalletWithPassword:(NSString *)password words:(NSArray <NSString *> *)words forgotPassword:(BOOL)forgotPassword;
@end
