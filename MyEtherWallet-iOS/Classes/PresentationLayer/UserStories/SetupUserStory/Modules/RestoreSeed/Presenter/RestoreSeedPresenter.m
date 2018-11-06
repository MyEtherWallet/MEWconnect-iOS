//
//  RestoreSeedPresenter.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 04/11/2018.
//  Copyright © 2018 MyEtherWallet, Inc.. All rights reserved.
//

#import "RestoreSeedPresenter.h"

#import "RestoreSeedViewInput.h"
#import "RestoreSeedInteractorInput.h"
#import "RestoreSeedRouterInput.h"
#import "RestoreSeedModuleOutput.h"

@implementation RestoreSeedPresenter

#pragma mark - RestoreSeedModuleInput

- (void)configureModuleWithAccount:(AccountPlainObject *)account password:(NSString *)password {
  [self.interactor configureWithAccount:account password:password];
}

#pragma mark - RestoreSeedViewOutput

- (void) didTriggerViewReadyEvent {
  [self.view setupInitialState];
}

- (void) cancelAction {
  [self.router close];
}

- (void) nextAction {
  [self.interactor tryRestore];
}

- (void) textDidChangedAction:(NSString *)text {
  [self.interactor checkMnemonics:text];
}

#pragma mark - RestoreSeedInteractorOutput

- (void) allowRestore {
  [self.view enableNext:YES];
}

- (void) disallowRestore {
  [self.view enableNext:NO];
}

- (void) restoreNotPossible {
  [self.view presentIncorrectMnemonicsWarning];
}

- (void) invalidMnemonics {
  [self.view presentInvalidMnemonicsWarning];
}

- (void) validMnemonicsWithPassword:(NSString *)password {
  [self.router close];
  [self.moduleOutput mnemonicsDidRestoredWithPassword:password];
}

@end
