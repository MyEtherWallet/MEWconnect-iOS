//
//  AboutPresenter.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 25/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "AboutPresenter.h"

#import "AboutViewInput.h"
#import "AboutInteractorInput.h"
#import "AboutRouterInput.h"

@implementation AboutPresenter

#pragma mark - AboutModuleInput

- (void) configureModule {
}

#pragma mark - AboutViewOutput

- (void) didTriggerViewReadyEvent {
	[self.view setupInitialState];
}

- (void) closeAction {
  [self.router close];
}

#pragma mark - AboutInteractorOutput

@end
