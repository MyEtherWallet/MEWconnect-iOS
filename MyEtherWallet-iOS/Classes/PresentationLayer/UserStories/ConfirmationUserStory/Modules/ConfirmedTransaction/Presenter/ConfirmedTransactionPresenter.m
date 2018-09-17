//
//  ConfirmedTransactionPresenter.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 19/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "ConfirmedTransactionPresenter.h"

#import "ConfirmedTransactionViewInput.h"
#import "ConfirmedTransactionInteractorInput.h"
#import "ConfirmedTransactionRouterInput.h"

typedef NS_ENUM(short, ConfirmedType) {
  ConfirmedTypeTransaction  = 0,
  ConfirmedTypeMessage      = 1,
};

@interface ConfirmedTransactionPresenter ()
@property (nonatomic) ConfirmedType type;
@end

@implementation ConfirmedTransactionPresenter

#pragma mark - ConfirmedTransactionModuleInput

- (void) configureModuleForMessage {
  self.type = ConfirmedTypeMessage;
}

- (void) configureModuleForTransaction {
  self.type = ConfirmedTypeTransaction;
}

#pragma mark - ConfirmedTransactionViewOutput

- (void) didTriggerViewReadyEvent {
  switch (self.type) {
    case ConfirmedTypeMessage: {
      [self.view setupInitialStateWithDescription:NSLocalizedString(@"The message is signed. Please continue in MyEtherWallet in your browser.", @"Confirmed message description")];
      break;
    }
    case ConfirmedTypeTransaction: {
      [self.view setupInitialStateWithDescription:NSLocalizedString(@"Transaction is generated and signed. Please continue in MyEtherWallet in your browser in order to send it.", @"Confirmed transaction description")];
      break;
    }
    default:
      break;
  }
}

- (void) closeAction {
  [self.moduleOutput transactionDidSigned];
}

#pragma mark - ConfirmedTransactionInteractorOutput

@end
