//
//  TransactionModuleInput.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;
@import ViperMcFlurryX;

@class MEWConnectCommand;
@class MasterTokenPlainObject;

@protocol TransactionModuleInput <RamblerViperModuleInput>
- (void) configureModuleWithMessage:(MEWConnectCommand *)command masterToken:(MasterTokenPlainObject *)masterToken;
@end
