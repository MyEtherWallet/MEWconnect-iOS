//
//  InfoRouter.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 24/06/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import ViperMcFlurry;

#import "InfoRouter.h"

#import "StartModuleInput.h"
#import "HomeModuleInput.h"

#import "ApplicationConstants.h"

static NSString *const kInfoToStartUnwindSegueIdentifier = @"InfoToStartUnwindSegueIdentifier";
static NSString *const kInfoToHomeUnwindSegueIdentifier = @"InfoToHomeUnwindSegueIdentifier";

@implementation InfoRouter

#pragma mark - InfoRouterInput

- (void) close {
  [self.transitionHandler closeCurrentModule:YES];
}

- (void) unwindToStart {
  [[self.transitionHandler openModuleUsingSegue:kInfoToStartUnwindSegueIdentifier] thenChainUsingBlock:^id<RamblerViperModuleOutput>(id<StartModuleInput> moduleInput) {
    [moduleInput configureModule];
    return nil;
  }];
}

- (void) unwindToHome {
  [[self.transitionHandler openModuleUsingSegue:kInfoToHomeUnwindSegueIdentifier] thenChainUsingBlock:^id<RamblerViperModuleOutput>(id<HomeModuleInput> moduleInput) {
    [moduleInput configureAfterChangingNetwork];
    return nil;
  }];
}

- (void) openMyEtherWalletCom {
  NSURL *url = [NSURL URLWithString:kMyEtherWalletComURL];
  if (url) {
    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
  }
}

- (void) openKnowledgeBase {
  NSURL *url = [NSURL URLWithString:kKnowledgeBaseURL];
  if (url) {
    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
  }
}

- (void) openPrivacyAndTerms {
  //TODO
}

@end
