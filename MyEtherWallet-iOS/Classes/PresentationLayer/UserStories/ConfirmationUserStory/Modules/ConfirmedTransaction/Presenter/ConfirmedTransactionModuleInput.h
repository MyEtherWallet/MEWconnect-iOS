//
//  ConfirmedTransactionModuleInput.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 19/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;
@import ViperMcFlurryX;

@protocol ConfirmedTransactionModuleInput <RamblerViperModuleInput>
- (void) configureModuleForTransaction;
- (void) configureModuleForMessage;
@end
