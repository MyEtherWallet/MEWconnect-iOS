//
//  SettingsPresenter.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "SettingsViewOutput.h"
#import "SettingsInteractorOutput.h"
#import "SettingsModuleInput.h"

@protocol SettingsViewInput;
@protocol SettingsInteractorInput;
@protocol SettingsRouterInput;

@interface SettingsPresenter : NSObject <SettingsModuleInput, SettingsViewOutput, SettingsInteractorOutput>

@property (nonatomic, weak) id<SettingsViewInput> view;
@property (nonatomic, strong) id<SettingsInteractorInput> interactor;
@property (nonatomic, strong) id<SettingsRouterInput> router;

@end
