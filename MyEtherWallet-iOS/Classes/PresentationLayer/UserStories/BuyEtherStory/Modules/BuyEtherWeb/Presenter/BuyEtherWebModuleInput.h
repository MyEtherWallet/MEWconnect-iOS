//
//  BuyEtherWebModuleInput.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 05/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc.. All rights reserved.
//

@import Foundation;
@import ViperMcFlurry;

@class SimplexOrder;
@class AccountPlainObject;

@protocol BuyEtherWebModuleInput <RamblerViperModuleInput>

- (void) configureModuleWithOrder:(SimplexOrder *)order forAccount:(AccountPlainObject *)account;

@end
