//
//  ShareModuleInput.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 11/10/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;
@import ViperMcFlurryX;

@class MasterTokenPlainObject;

@protocol ShareModuleInput <RamblerViperModuleInput>
- (void) configureModuleWithMasterToken:(MasterTokenPlainObject *)masterToken;
@end
