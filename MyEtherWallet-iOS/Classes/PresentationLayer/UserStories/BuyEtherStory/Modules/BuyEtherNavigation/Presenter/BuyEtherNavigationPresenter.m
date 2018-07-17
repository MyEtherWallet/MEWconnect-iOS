//
//  BuyEtherNavigationPresenter.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 03/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "BuyEtherNavigationPresenter.h"

#import "BuyEtherNavigationViewInput.h"
#import "BuyEtherNavigationRouterInput.h"

@implementation BuyEtherNavigationPresenter

#pragma mark - BuyEtherNavigationModuleInput

- (void) configureModule {
}

#pragma mark - BuyEtherNavigationViewOutput

- (void) didTriggerViewReadyEvent {
	[self.view setupInitialState];
}

@end
