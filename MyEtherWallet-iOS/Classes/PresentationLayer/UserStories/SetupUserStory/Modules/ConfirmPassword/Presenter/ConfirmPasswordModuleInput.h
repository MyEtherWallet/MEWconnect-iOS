//
//  ConfirmPasswordModuleInput.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 01/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;
@import ViperMcFlurryX;

@protocol ConfirmPasswordModuleInput <RamblerViperModuleInput>
- (void) configureModuleWithPassword:(NSString *)password words:(NSArray <NSString *> *)words forgotPassword:(BOOL)forgotPassword;
@end
