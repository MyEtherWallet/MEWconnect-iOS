//
//  BuyEtherHistoryModuleInput.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 02/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;
@import ViperMcFlurryX;

@class MasterTokenPlainObject;

@protocol BuyEtherHistoryModuleInput <RamblerViperModuleInput>
- (void) configureModuleWithMasterToken:(MasterTokenPlainObject *)masterToken;
@end
