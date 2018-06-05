//
//  HomeModuleInput.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;
@import ViperMcFlurry;

@protocol HomeModuleInput <RamblerViperModuleInput>
- (void) configureModuleWithAddress:(NSString *)address;
- (void) configuraBackupStatus;
@end
