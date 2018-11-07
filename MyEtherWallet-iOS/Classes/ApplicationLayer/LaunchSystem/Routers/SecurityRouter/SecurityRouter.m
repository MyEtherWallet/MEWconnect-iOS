//
//  SecurityRouter.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 06/11/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import ViperMcFlurryX;

#import "SecurityRouter.h"

#import "SecurityService.h"
#import "AccountsService.h"

#import "Ponsomizer.h"

#import "AccountPlainObject.h"

#import "SplashPasswordViewController.h"
#import "SplashPasswordModuleInput.h"

#import "ContextPasswordViewController.h"
#import "QRScannerViewController.h"
#import "RestoreWalletViewController.h"

#import "UIResponder+FindFirstResponder.h"
#import "UIViewController+Hierarchy.h"

@interface SecurityRouter ()
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) UIView *secureView;
@property (nonatomic, weak) UIResponder *lastFirstResponder;
@end

static UIViewController *test;

@implementation SecurityRouter {
  BOOL _secured;
}

#pragma mark - LifeCycle

- (instancetype)initWithWindow:(UIWindow *)window {
  self = [super init];
  if (self) {
    self.window = window;
  }
  return self;
}

#pragma mark - Override

- (UIView *) secureView {
  if (!_secureView) {
    UIView *view = [[UIView alloc] initWithFrame:self.window.bounds];
    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mew_logo"]];
    logo.translatesAutoresizingMaskIntoConstraints = NO;
    
    if (!UIAccessibilityIsReduceTransparencyEnabled()) {
      view.backgroundColor = [UIColor clearColor];
      
      UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleProminent];
      UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];

      blurEffectView.frame = view.bounds;
      [view addSubview:blurEffectView];
      blurEffectView.translatesAutoresizingMaskIntoConstraints = NO;
      [NSLayoutConstraint activateConstraints:
       @[[blurEffectView.topAnchor constraintEqualToAnchor:view.topAnchor],
         [blurEffectView.leftAnchor constraintEqualToAnchor:view.leftAnchor],
         [blurEffectView.bottomAnchor constraintEqualToAnchor:view.bottomAnchor],
         [blurEffectView.rightAnchor constraintEqualToAnchor:view.rightAnchor]]
       ];
      [blurEffectView.contentView addSubview:logo];
    } else {
      view.backgroundColor = [UIColor whiteColor];
      [view addSubview:logo];
    }
    
    [NSLayoutConstraint activateConstraints:
     @[[logo.centerXAnchor constraintEqualToAnchor:logo.superview.centerXAnchor],
       [logo.centerYAnchor constraintEqualToAnchor:logo.superview.centerYAnchor]]
     ];
    
    _secureView = view;
  }
  return _secureView;
}

#pragma mark - Public

- (void) openSecureView {
  if (!_secured && [self _shouldProtectData]) {
    _secured = YES;
    
    [self.window addSubview:self.secureView];
    UIWindow *keyboardCandidateWindow = [[UIApplication sharedApplication].windows lastObject];
    if (![self.window isEqual:keyboardCandidateWindow]) {
      keyboardCandidateWindow.hidden = YES;
      
      self.lastFirstResponder = [self.window findFirstResponder];
      if (!self.lastFirstResponder) {
        self.lastFirstResponder = [self.window.rootViewController findFirstResponder];
      }
      self.lastFirstResponder.inputAccessoryView.hidden = YES;
      
      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.lastFirstResponder resignFirstResponder];
        keyboardCandidateWindow.hidden = NO;
        self.lastFirstResponder.inputAccessoryView.hidden = NO;
      });
    }
  }
}

- (void) closeSecureView {
  if (_secured) {
    _secured = NO;
    if ([self.securityService obtainProtectionStatus]) {
      [self openPasswordProtectionWithCompletion:^{
        [UIView animateWithDuration:0.3
                         animations:^{
                           self.secureView.alpha = 0.0;
                         } completion:^(__unused BOOL finished) {
                           [self.secureView removeFromSuperview];
                           self.secureView.alpha = 1.0;
                         }];
      }];
    } else {
      [UIView animateWithDuration:0.3
                       animations:^{
                         self.secureView.alpha = 0.0;
                       } completion:^(__unused BOOL finished) {
                         [self.secureView removeFromSuperview];
                         self.secureView.alpha = 1.0;
                         if ([self.lastFirstResponder canBecomeFirstResponder]) {
                           [self.lastFirstResponder becomeFirstResponder];
                         }
                       }];
    }
  }
}

- (void) openPasswordProtectionWithCompletion:(void (^ __nullable)(void))completion {
  AccountModelObject *accountModelObject = [self.accountsService obtainActiveAccount];
  
  NSArray *ignoringProperties = @[NSStringFromSelector(@selector(networks))];
  AccountPlainObject *account = [self.ponsomizer convertObject:accountModelObject ignoringProperties:ignoringProperties];
  if (!accountModelObject) {
    if (completion) {
      completion();
    }
    return;
  }
  UIViewController *topViewController = [self.window.rootViewController obtainTopController];
  BOOL splashExist = [self.window.rootViewController isExistInHierarchy:[SplashPasswordViewController class]];
  if (splashExist) {
    if (completion) {
      completion();
    }
    return;
  }
  
  NSArray *classesForDismiss = @[NSStringFromClass([QRScannerViewController class]),
                                 NSStringFromClass([ContextPasswordViewController class]),
                                 NSStringFromClass([UIAlertController class])];
  
  if ([classesForDismiss containsObject:NSStringFromClass([topViewController class])]) {
    [topViewController dismissViewControllerAnimated:NO
                                          completion:^{
                                            [self _openPasswordWithAccount:account completion:completion];
                                          }];
  } else {
    [self _openPasswordWithAccount:account completion:completion];
  }
}

#pragma mark - Private

- (BOOL) _shouldProtectData {
  AccountModelObject *accountModelObject = [self.accountsService obtainActiveAccount];
  BOOL restoreExist = [self.window.rootViewController isExistInHierarchy:[RestoreWalletViewController class]];
  return accountModelObject != nil || restoreExist;
}

- (void) _openPasswordWithAccount:(AccountPlainObject *)account completion:(void (^ __nullable)(void))completion {
  UIViewController *topViewController = [self.window.rootViewController obtainTopController];
  [[topViewController openModuleUsingFactory:self.splashPasswordFactory
                         withTransitionBlock:^(id<RamblerViperModuleTransitionHandlerProtocol> sourceModuleTransitionHandler, id<RamblerViperModuleTransitionHandlerProtocol> destinationModuleTransitionHandler) {
                           UIViewController *destinationViewController = (id)destinationModuleTransitionHandler;
                           UIViewController *sourceViewController = (id)sourceModuleTransitionHandler;
                           [sourceViewController presentViewController:destinationViewController
                                                              animated:NO
                                                            completion:completion];
                         }] thenChainUsingBlock:^id<RamblerViperModuleOutput>(id<SplashPasswordModuleInput> moduleInput) {
                           [moduleInput configureModuleWithAccount:account autoControl:YES];
                           return nil;
                         }];
}

@end
