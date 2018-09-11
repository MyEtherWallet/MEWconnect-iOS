//
//  InfoRouter.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 24/06/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import ViperMcFlurryX;

#import "InfoRouter.h"

#import "StartModuleInput.h"
#import "AboutModuleInput.h"

#import "ApplicationConstants.h"

static NSString *const kInfoToStartUnwindSegueIdentifier = @"InfoToStartUnwindSegueIdentifier";
static NSString *const kInfoToAboutSegueIdentifier = @"InfoToAboutSegueIdentifier";

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
  NSURL *url = [NSURL URLWithString:kPrivacyAndTermsURL];
  if (url) {
    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
  }
}

- (void) openUserGuide {
  NSURL *url = [NSURL URLWithString:kUserGuideURL];
  if (url) {
    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
  }
}

- (void)openAbout {
  [[self.transitionHandler openModuleUsingSegue:kInfoToAboutSegueIdentifier] thenChainUsingBlock:^id<RamblerViperModuleOutput>(id<AboutModuleInput> moduleInput) {
    [moduleInput configureModule];
    return nil;
  }];
}

@end
