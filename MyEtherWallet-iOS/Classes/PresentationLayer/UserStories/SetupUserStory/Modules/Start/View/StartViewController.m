//
//  StartViewController.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 14/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "StartViewController.h"

#import "StartViewOutput.h"

#import "UIImage+MEWBackground.h"

@interface StartViewController () <UIScrollViewDelegate>
@property (nonatomic, weak) IBOutlet UIButton *createNewWalletButton;
@property (nonatomic, weak) IBOutlet UIButton *restoreWalletButton;
@property (nonatomic, weak) IBOutlet UILabel *mewConnectTitle;
@property (nonatomic, weak) IBOutlet UILabel *byMyEtherWalletTitle;
@property (nonatomic, weak) IBOutlet UIPageControl *pageControl;
@end

@implementation StartViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
	[super viewDidLoad];
  [self.output didTriggerViewReadyEvent];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.output didTriggerViewWillAppearEvent];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
  return UIStatusBarStyleLightContent;
}

#pragma mark - StartViewInput

- (void) setupInitialState {
  { //Create new wallet
    self.createNewWalletButton.layer.shadowColor = [UIColor blackColor].CGColor;
    self.createNewWalletButton.layer.shadowOpacity = 0.1;
    self.createNewWalletButton.layer.shadowRadius = 12.0;
    self.createNewWalletButton.layer.shadowOffset = CGSizeMake(0.0, 6.0);
  }
  { //Restore wallet
    NSDictionary *attributes = @{NSForegroundColorAttributeName: [self.restoreWalletButton titleColorForState:UIControlStateNormal],
                                 NSFontAttributeName: self.restoreWalletButton.titleLabel.font,
                                 NSKernAttributeName: @(0.3)};
    [self.restoreWalletButton setAttributedTitle:[[NSAttributedString alloc] initWithString:[self.restoreWalletButton titleForState:UIControlStateNormal]
                                                                                 attributes:attributes]
                                        forState:UIControlStateNormal];
  }
  { //MEWconnect
    NSDictionary *attributes = @{NSFontAttributeName: self.byMyEtherWalletTitle.font,
                                 NSForegroundColorAttributeName: self.byMyEtherWalletTitle.textColor,
                                 NSKernAttributeName: @(0.21)};
    self.byMyEtherWalletTitle.attributedText = [[NSAttributedString alloc] initWithString:self.byMyEtherWalletTitle.text attributes:attributes];
  }
  {
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 0.0;
    style.maximumLineHeight = 60.0;
    style.minimumLineHeight = 60.0;
    UIFont *font = self.mewConnectTitle.font;
    NSNumber *offset = @(font.capHeight - font.ascender + 2.0);
    NSDictionary *attributes = @{NSFontAttributeName: font,
                                 NSForegroundColorAttributeName: self.mewConnectTitle.textColor,
                                 NSParagraphStyleAttributeName: style,
                                 NSBaselineOffsetAttributeName: offset};
    self.mewConnectTitle.attributedText = [[NSAttributedString alloc] initWithString:self.mewConnectTitle.text attributes:attributes];
  }
}

#pragma mark - IBActions

- (IBAction) createNewWallet:(UIButton *)sender {
  [self.output createNewWalletAction];
}

- (IBAction) restoreWallet:(UIButton *)sender {
  [self.output restoreWallet];
}

- (IBAction)unwindToStart:(UIStoryboardSegue *)sender {}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  CGFloat pageWidth = CGRectGetWidth(scrollView.bounds);
  CGFloat fPage = scrollView.contentOffset.x / pageWidth;
  NSInteger page = lround(fPage);
  self.pageControl.currentPage = page;
}

@end
