//
//  ConfirmationNavigationModuleInput.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 17/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;
@import ViperMcFlurryX;

@protocol ConfirmationNavigationModuleInput <RamblerViperModuleInput>
- (void) configureModule;
- (void) closeWithCompletion:(ModuleCloseCompletionBlock)completion;
@end
