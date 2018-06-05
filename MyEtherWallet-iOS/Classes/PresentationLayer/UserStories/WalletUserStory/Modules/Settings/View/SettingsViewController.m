//
//  SettingsViewController.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "SettingsViewController.h"

#import "SettingsViewOutput.h"

@implementation SettingsViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
	[super viewDidLoad];

	[self.output didTriggerViewReadyEvent];
}

#pragma mark - SettingsViewInput

- (void) setupInitialState {
}

@end
