//
//  ContextPasswordModuleInput.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 11/09/2018.
//  Copyright © 2018 MyEtherWallet, Inc.. All rights reserved.
//

@import Foundation;
@import ViperMcFlurryX;

@class AccountPlainObject;

@protocol ContextPasswordModuleInput <RamblerViperModuleInput>
- (void) configureModuleWithAccount:(AccountPlainObject *)account;
@end
