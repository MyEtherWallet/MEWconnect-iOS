//
//  NewWalletPresenter.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "NewWalletPresenter.h"

#import "NewWalletViewInput.h"
#import "NewWalletInteractorInput.h"
#import "NewWalletRouterInput.h"

@implementation NewWalletPresenter {
  BOOL _forgotPassword;
}

#pragma mark - NewWalletModuleInput

- (void)configureModuleWithPassword:(NSString *)password words:(NSArray<NSString *> *)words forgotPassword:(BOOL)forgotPassword {
  _forgotPassword = forgotPassword;
  [self.interactor createNewWalletWithPassword:password words:words];
}

#pragma mark - NewWalletViewOutput

- (void)didTriggerViewReadyEvent {
	[self.view setupInitialState];
}

- (void)startUsingAction {
  NSString *address = [self.interactor obtainWalletAddress];
  if (_forgotPassword) {
    [self.router unwindToWalletWithAddress:address];
  } else {
    [self.router unwindToStartWithAddress:address];
  }
}

#pragma mark - NewWalletInteractorOutput

@end
