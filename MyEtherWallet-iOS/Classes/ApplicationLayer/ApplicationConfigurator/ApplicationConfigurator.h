//
//  ApplicationConfigurator.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 15/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@protocol ApplicationConfigurator <NSObject>
- (void)setupCoreDataStack;
- (void)configureInitialSettings;
- (void)configurateAppearance;
@end
