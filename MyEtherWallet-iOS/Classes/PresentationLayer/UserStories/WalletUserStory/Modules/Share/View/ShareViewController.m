//
//  ShareViewController.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 11/10/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "ShareViewController.h"

#import "ShareViewOutput.h"

#import "UIScreen+ScreenSizeType.h"

#import "ApplicationConstants.h"

#import "UIView+LockFrame.h"

@interface ShareViewController ()
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, weak) IBOutlet UILabel *addressLabel;
@property (nonatomic, weak) IBOutlet UIImageView *qrCodeImageView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *buttonsWidthProportion;
@end

@implementation ShareViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
  [super viewDidLoad];
  self.modalPresentationCapturesStatusBarAppearance = YES;
  [self.output didTriggerViewReadyEvent];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.output didTriggerViewWillAppearEvent];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  self.view.lockFrame = YES;
}

- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
  [self.output didTriggerViewWillDisappearEvent];
}

- (void)viewLayoutMarginsDidChange {
  [super viewLayoutMarginsDidChange];
  [self _updatePrefferedContentSize];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
  return UIStatusBarStyleLightContent;
}

#pragma mark - Override

- (void)setCustomTransitioningDelegate:(id<UIViewControllerTransitioningDelegate>)customTransitioningDelegate {
  _customTransitioningDelegate = customTransitioningDelegate;
  self.transitioningDelegate = customTransitioningDelegate;
}

#pragma mark - ShareViewInput

- (void) setupInitialStateWithAddress:(NSString *)address qrCode:(UIImage *)qrCode {
  self.qrCodeImageView.image = qrCode;
  [self _updatePrefferedContentSize];
  
  CGFloat titleKern = -0.3;
  if ([UIScreen mainScreen].screenSizeType == ScreenSizeTypeInches40) {
    titleKern = -1.1;
    self.buttonsWidthProportion.constant = 72.0;
  }
  { //Title label
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 0.0;
    UIFont *font = self.titleLabel.font;
    style.maximumLineHeight = 36.0;
    style.minimumLineHeight = 36.0;
    NSDictionary *attributes = @{NSFontAttributeName: font,
                                 NSForegroundColorAttributeName: self.titleLabel.textColor,
                                 NSParagraphStyleAttributeName: style,
                                 NSKernAttributeName: @(titleKern)};
    self.titleLabel.attributedText = [[NSAttributedString alloc] initWithString:self.titleLabel.text attributes:attributes];
  }
  { //Description
    NSArray *infoParts = [self.descriptionLabel.text componentsSeparatedByString:@"\n"];
    NSMutableAttributedString *attributedInfoText = [[NSMutableAttributedString alloc] init];
    for (NSInteger i = 0; i < [infoParts count]; ++i) {
      NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
      style.lineSpacing = 5.0;
      if (i != [infoParts count] - 1) {
        style.paragraphSpacing = 9.0;
      }
      NSDictionary *attributes = @{NSFontAttributeName: self.descriptionLabel.font,
                                   NSForegroundColorAttributeName: self.descriptionLabel.textColor,
                                   NSParagraphStyleAttributeName: style,
                                   NSKernAttributeName: @(-0.01)};
      NSString *part = infoParts[i];
      if (i != [infoParts count] - 1) {
        part = [part stringByAppendingString:@"\n"];
      }
      [attributedInfoText appendAttributedString:[[NSAttributedString alloc] initWithString:part attributes:attributes]];
    }
    
    self.descriptionLabel.attributedText = attributedInfoText;
  }
  { //Address
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentCenter;
    style.lineSpacing = 5.0;
    NSDictionary *attributes = @{NSFontAttributeName: self.addressLabel.font,
                                 NSForegroundColorAttributeName: self.addressLabel.textColor,
                                 NSParagraphStyleAttributeName: style,
                                 NSKernAttributeName: @(-0.01)};
    if (address) {
      NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:address attributes:attributes];
      self.addressLabel.attributedText = attributedText;
    } else {
      self.addressLabel.text = nil;
    }
  }
}

- (void) presentShareWithItems:(NSArray *)items {
  UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];
  [self presentViewController:activityController animated:YES completion:nil];
}

#pragma mark - IBActions

- (IBAction) closeAction:(__unused id)sender {
  [self.output closeAction];
}

- (IBAction) copyAction:(__unused id)sender {
  [self.output copyAction];
}

- (IBAction) shareAction:(__unused id)sender {
  [self.output shareAction];
}

#pragma mark - Private

- (void) _updatePrefferedContentSize {
  CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
  CGRect bounds = self.presentingViewController.view.window.bounds;
  CGSize size = bounds.size;
  size.height -= CGRectGetHeight(statusBarFrame);
  size.height -= kCustomRepresentationTopSmallOffset;
  if (!CGSizeEqualToSize(self.preferredContentSize, size)) {
    self.preferredContentSize = size;
  }
}

@end
