//
//  RestoreOptionsModuleInput.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 18/02/2019.
//  Copyright © 2019 MyEtherWallet, Inc.. All rights reserved.
//

@import Foundation;
@import ViperMcFlurryX;

@protocol RestoreOptionsModuleInput <RamblerViperModuleInput>

- (void) configureModuleWhileForgotPassword:(BOOL)forgotPassword;

@end
