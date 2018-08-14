//
//  ForgotPasswordModuleInput.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 27/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;
@import ViperMcFlurryX;

@class AccountPlainObject;

@protocol ForgotPasswordModuleInput <RamblerViperModuleInput>
- (void) configureModuleWithAccount:(AccountPlainObject *)account;
@end
