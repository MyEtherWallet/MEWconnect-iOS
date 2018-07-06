//
//  BuyEtherWebPresenter.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 05/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc.. All rights reserved.
//

#import "BuyEtherWebPresenter.h"

#import "BuyEtherWebViewInput.h"
#import "BuyEtherWebInteractorInput.h"
#import "BuyEtherWebRouterInput.h"

@implementation BuyEtherWebPresenter

#pragma mark - BuyEtherWebModuleInput

- (void) configureModuleWithOrder:(SimplexOrder *)order forAccount:(AccountPlainObject *)account {
  [self.interactor configurateWithOrder:order account:account];
}

#pragma mark - BuyEtherWebViewOutput

- (void) didTriggerViewReadyEvent {
  NSURLRequest *request = [self.interactor obtainInitialRequest];
  [self.view setupInitialStateWithRequest:request];
}

- (void) doneAction {
  [self.router close];
}

#pragma mark - BuyEtherWebInteractorOutput

@end
