//
//  SettingsAssembly_Testable.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "SettingsAssembly.h"

@class SettingsViewController;
@class SettingsInteractor;
@class SettingsPresenter;
@class SettingsRouter;

@interface SettingsAssembly ()

- (SettingsViewController *)viewSettings;
- (SettingsPresenter *)presenterSettings;
- (SettingsInteractor *)interactorSettings;
- (SettingsRouter *)routerSettings;

@end
