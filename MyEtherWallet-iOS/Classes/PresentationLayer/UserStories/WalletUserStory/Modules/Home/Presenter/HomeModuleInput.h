//
//  HomeModuleInput.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;
@import ViperMcFlurryX;

@protocol HomeModuleInput <RamblerViperModuleInput>
- (void) configureModule;
- (void) configureBackupStatus;
- (void) configureAfterChangingNetwork;
@end
