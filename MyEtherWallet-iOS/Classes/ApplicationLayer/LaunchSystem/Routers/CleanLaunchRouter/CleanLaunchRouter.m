//
//  CleanLaunchRouter.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 15/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import UIKit;
@import ViperMcFlurryX;
@import libextobjc.EXTScope;

#import "CleanLaunchRouter.h"
#import "NavigationControllerFactory.h"
#import "PropertyAnimatorsFactory.h"

#import "AccountsService.h"
#import "Ponsomizer.h"
#import "WhatsNewService.h"

#import "NetworkPlainObject.h"
#import "AccountPlainObject.h"

#import "SplashPasswordModuleInput.h"

#import "UIVIewController+Hierarchy.h"

static NSInteger const kSplashPasswordLogoImageViewTag          = 1;

@interface CleanLaunchRouter ()
@property (nonatomic, strong) id <NavigationControllerFactory> navigationControllerFactory;
@property (nonatomic, strong) UIWindow *window;
@end

@implementation CleanLaunchRouter

#pragma mark - Initialization

- (instancetype)initWithNavigationControllerFactory:(id<NavigationControllerFactory>)navigationControllerFactory
                                             window:(UIWindow *)window {
  self = [super init];
  if (self) {
    _navigationControllerFactory = navigationControllerFactory;
    _window = window;
  }
  return self;
}

#pragma mark - Public

- (void)openInitialScreen {
  AccountModelObject *accountModelObject = [self.accountsService obtainActiveAccount];
  
  NSArray *ignoringProperties = @[NSStringFromSelector(@selector(networks))];
  AccountPlainObject *account = [self.ponsomizer convertObject:accountModelObject ignoringProperties:ignoringProperties];
  UINavigationController *navigationController = nil;
  if (accountModelObject) {
    navigationController = [self.navigationControllerFactory obtainPreconfiguredAuthorizedNavigationController];
  } else {
    navigationController = [self.navigationControllerFactory obtainPreconfiguredNavigationController];
  }
  
  self.window.rootViewController = navigationController;
  [self.window makeKeyAndVisible];
  
  UIViewController *launchViewController = [self.launchStoryboard instantiateInitialViewController];
  launchViewController.view.frame = self.window.bounds;
  launchViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  
  [self.window addSubview:launchViewController.view];
  
  @weakify(self);
  if (accountModelObject) {
    /* To prevent "Unbalanced calls to begin/end appearance transitions for..." */
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
      dispatch_async(dispatch_get_main_queue(), ^{
        @strongify(self);
        __block id <SplashPasswordModuleInput> passwordModuleInput = nil;
        RamblerViperModuleLinkBlock linkBlock = [self passwordConfigurationBlockWithAccount:account moduleInputCatch:^(id<SplashPasswordModuleInput> moduleInput) {
          passwordModuleInput = moduleInput;
        }];
        [[navigationController.topViewController openModuleUsingFactory:self.splashPasswordFactory
                                                    withTransitionBlock:[self passwordTransitionBlockWithCompletion:^{
          [self _animateSplash:launchViewController parentView:navigationController.topViewController.presentedViewController.presentationController.containerView withCompletion:^{
            [launchViewController.view removeFromSuperview];
            [self _presentWhatsNewIfNeededIn:navigationController completion:^{
              [passwordModuleInput takeControlAfterLaunch];
            }];
          }];
        }]] thenChainUsingBlock:linkBlock];
      });
    });
  } else {
    [self _animateSplash:launchViewController parentView:self.window.rootViewController.view withCompletion:^{
      [launchViewController.view removeFromSuperview];
      @strongify(self);
      [self _presentWhatsNewIfNeededIn:navigationController completion:nil];
    }];
  }
}

#pragma mark - Private

- (ModuleTransitionBlock) passwordTransitionBlockWithCompletion:(void(^)(void))completion {
  return ^(id<RamblerViperModuleTransitionHandlerProtocol> sourceModuleTransitionHandler, id<RamblerViperModuleTransitionHandlerProtocol> destinationModuleTransitionHandler) {
    UIViewController *destinationViewController = (id)destinationModuleTransitionHandler;
    UIViewController *sourceViewController = (id)sourceModuleTransitionHandler;
    [sourceViewController presentViewController:destinationViewController
                                       animated:NO
                                     completion:completion];
  };
}

- (RamblerViperModuleLinkBlock) passwordConfigurationBlockWithAccount:(AccountPlainObject *)account moduleInputCatch:(void(^)(id<SplashPasswordModuleInput> moduleInput))moduleCatchBlock {
  return ^id<RamblerViperModuleOutput>(id<SplashPasswordModuleInput> moduleInput) {
    moduleCatchBlock(moduleInput);
    [moduleInput configureModuleWithAccount:account autoControl:NO];
    return nil;
  };
}

- (void) _animateSplash:(UIViewController *)launchViewController parentView:(UIView *)parentView withCompletion:(void(^)(void))completion {
  [launchViewController.view.superview bringSubviewToFront:launchViewController.view];
  UIImageView *logoImageView = (UIImageView *)[launchViewController.view viewWithTag:kSplashPasswordLogoImageViewTag];
  CGFloat originalImageWidth = logoImageView.image.size.width;
  NSLayoutConstraint *widthConstraint = [logoImageView.widthAnchor constraintEqualToConstant:originalImageWidth];
  widthConstraint.active = YES;
  [launchViewController.view layoutIfNeeded];
  UIViewPropertyAnimator *animator = [self.propertyAnimatorsFactory mewQuatroPropertyAnimatorWithDuration:@1.1];
  
  [logoImageView setImage:[UIImage imageNamed:@"mew_logo_scaled"]];
  
  CGFloat firstPartAnimationDuration = 1.0/3.0;
  
  [animator addAnimations:^{
    [UIView animateKeyframesWithDuration:0.0
                                   delay:0.0
                                 options:0
                              animations:^{
                                [UIView addKeyframeWithRelativeStartTime:0.0
                                                        relativeDuration:firstPartAnimationDuration
                                                              animations:^{
                                                                parentView.transform = CGAffineTransformMakeScale(1.1, 1.1);
                                                                widthConstraint.constant = 0.9 * originalImageWidth;
                                                                [launchViewController.view layoutIfNeeded];
                                                              }];
                                [UIView addKeyframeWithRelativeStartTime:firstPartAnimationDuration
                                                        relativeDuration:1.0 - firstPartAnimationDuration
                                                              animations:^{
                                                                parentView.transform = CGAffineTransformIdentity;
                                                                launchViewController.view.alpha = 0.0;
                                                                widthConstraint.constant = 16.0 * originalImageWidth;
                                                                [launchViewController.view layoutIfNeeded];
                                                              }];
                              } completion:^(__unused BOOL finished) {
                                
                              }];
    
  }];
  [animator addCompletion:^(__unused UIViewAnimatingPosition finalPosition) {
    if (completion) {
      completion();
    }
  }];
  [animator startAnimation];
}

- (void) _presentWhatsNewIfNeededIn:(UINavigationController *)navigationController completion:(void(^)(void))completion {
  if (![self.whatsNewService shouldShowWhatsNew]) {
    if (completion) {
      completion();
    }
    return;
  }
  NSString *message = [self.whatsNewService currentWhatsNew];
  if (!message || [message length] == 0) {
    if (completion) {
      completion();
    }
    return;
  }
  [self.whatsNewService registerShow];
  UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"What's new", @"What's new alert")
                                                                 message:message
                                                          preferredStyle:UIAlertControllerStyleAlert];
  [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Ok", nil)
                                            style:UIAlertActionStyleDefault
                                          handler:^(__unused UIAlertAction * _Nonnull action) {
                                            if (completion) {
                                              completion();
                                            }
                                          }]];
  NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
  style.alignment = NSTextAlignmentLeft;
  NSDictionary *attributes = @{NSParagraphStyleAttributeName: style,
                               NSFontAttributeName: [UIFont preferredFontForTextStyle: UIFontTextStyleFootnote]};
  NSAttributedString *attributedMessage = [[NSAttributedString alloc] initWithString:message
                                                                          attributes:attributes];
  @try {
    [alert setValue:attributedMessage forKey:@"attributedMessage"];
  } @catch (NSException *exception) {
  } @finally {
  }
  [[navigationController obtainTopController] presentViewController:alert animated:YES completion:nil];
}

@end
