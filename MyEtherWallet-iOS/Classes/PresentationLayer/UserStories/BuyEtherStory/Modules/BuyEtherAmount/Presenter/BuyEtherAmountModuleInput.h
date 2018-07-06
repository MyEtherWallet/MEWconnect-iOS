//
//  BuyEtherAmountModuleInput.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 02/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;
@import ViperMcFlurry;

@class AccountPlainObject;

@protocol BuyEtherAmountModuleInput <RamblerViperModuleInput>

- (void) configureModuleWithAccount:(AccountPlainObject *)account;

@end
