//
//  InfoModuleInput.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 24/06/2018.
//  Copyright © 2018 MyEtherWallet, Inc.. All rights reserved.
//

@import Foundation;
@import ViperMcFlurry;

@class AccountPlainObject;

@protocol InfoModuleInput <RamblerViperModuleInput>

- (void) configureModuleWithAccount:(AccountPlainObject *)account;

@end
