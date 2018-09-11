//
//  TransitioningDelegateAssembly.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 26/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "TransitioningDelegateAssembly.h"

#import "PresentationControllerType.h"

#import "TransitioningDelegateBase.h"

#import "BottomModalPresentingAnimationController.h"
#import "BottomModalDismissingAnimationController.h"

#import "FadeModalPresentingAnimationController.h"
#import "FadeModalDismissingAnimationController.h"

@implementation TransitioningDelegateAssembly

#pragma mark - Option matcher

- (id<UIViewControllerTransitioningDelegate>)transitioningDelegateWithType:(NSNumber *)type cornerRadius:(NSNumber *)cornerRadius {
  return [TyphoonDefinition withOption:type matcher:^(TyphoonOptionMatcher *matcher) {
    [matcher caseEqual:@(TransitioningDelegateDefaultType)
                   use:nil];
    [matcher caseEqual:@(TransitioningDelegateBottomModal)
                   use:[self bottomModalTransitioningDelegateWithCornerRadius:cornerRadius]];
    [matcher caseEqual:@(TransitioningDelegateBottomBackgroundedModal)
                   use:[self bottomBackgroundedModalTransitioningDelegateWithCornerRadius:cornerRadius]];
    [matcher caseEqual:@(TransitioningDelegateFadeModal)
                   use:[self fadeModalTransitioningDelegate]];
  }];
}

#pragma mark - Concrete definitions

- (id<UIViewControllerTransitioningDelegate>) bottomModalTransitioningDelegateWithCornerRadius:(NSNumber *)cornerRadius {
  return [TyphoonDefinition withClass:[TransitioningDelegateBase class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(presentationControllerType)
                                                with:@(PresentationControllerBottomModalType)];
                          [definition injectProperty:@selector(presentingAnimationController)
                                                with:[self bottomModalPresentingAnimationController]];
                          [definition injectProperty:@selector(dismissingAnimationController)
                                                with:[self bottomModalDismissingAnimationController]];
                          [definition injectProperty:@selector(presentationControllerFactory)
                                                with:self.presentationControllerFactory];
                          [definition injectProperty:@selector(cornerRadius)
                                                with:cornerRadius];
                        }];
}

- (id<UIViewControllerTransitioningDelegate>) bottomBackgroundedModalTransitioningDelegateWithCornerRadius:(NSNumber *)cornerRadius {
  return [TyphoonDefinition withClass:[TransitioningDelegateBase class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(presentationControllerType)
                                                with:@(PresentationControllerBottomBackgroundedModalType)];
                          [definition injectProperty:@selector(presentingAnimationController)
                                                with:[self bottomModalPresentingAnimationController]];
                          [definition injectProperty:@selector(dismissingAnimationController)
                                                with:[self bottomModalDismissingAnimationController]];
                          [definition injectProperty:@selector(presentationControllerFactory)
                                                with:self.presentationControllerFactory];
                          [definition injectProperty:@selector(cornerRadius)
                                                with:cornerRadius];
                        }];
}

- (id<UIViewControllerTransitioningDelegate>) fadeModalTransitioningDelegate {
  return [TyphoonDefinition withClass:[TransitioningDelegateBase class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(presentationControllerType)
                                                with:@(PresentationControllerBottomModalType)];
                          [definition injectProperty:@selector(presentingAnimationController)
                                                with:[self fadeModalPresentingAnimationController]];
                          [definition injectProperty:@selector(dismissingAnimationController)
                                                with:[self fadeModalDismissingAnimationController]];
                          [definition injectProperty:@selector(presentationControllerFactory)
                                                with:self.presentationControllerFactory];
                        }];
}

#pragma mark - Presenting Animation Controllers

- (BottomModalPresentingAnimationController *) bottomModalPresentingAnimationController {
  return [TyphoonDefinition withClass:[BottomModalPresentingAnimationController class]];
}

- (FadeModalPresentingAnimationController *) fadeModalPresentingAnimationController {
  return [TyphoonDefinition withClass:[FadeModalPresentingAnimationController class]];
}

#pragma mark - Dismissing Animation Controllers

- (BottomModalDismissingAnimationController *) bottomModalDismissingAnimationController {
  return [TyphoonDefinition withClass:[BottomModalDismissingAnimationController class]];
}

- (FadeModalDismissingAnimationController *) fadeModalDismissingAnimationController {
  return [TyphoonDefinition withClass:[FadeModalDismissingAnimationController class]];
}

@end
