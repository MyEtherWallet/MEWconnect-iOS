//
//  InfoViewController.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 24/06/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import libextobjc.EXTScope;
@import MessageUI;

#import "InfoViewController.h"

#import "InfoViewOutput.h"

#import "InfoDataDisplayManager.h"

#import "ApplicationConstants.h"

#import "UIView+LockFrame.h"
#import "UIScreen+ScreenSizeType.h"

@interface InfoViewController () <InfoDataDisplayManagerDelegate, MFMailComposeViewControllerDelegate>
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UILabel *versionLabel;
@property (nonatomic, weak) IBOutlet UILabel *copyrightLabel;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *versionTopOffsetConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *titleTopOffsetConstraint;
@end

@implementation InfoViewController {
  NSTimer *_testnetTimer;
}

#pragma mark - LifeCycle

- (void)viewDidLoad {
  [super viewDidLoad];
  self.modalPresentationCapturesStatusBarAppearance = YES;
  [self.output didTriggerViewReadyEvent];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  self.view.lockFrame = YES;
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

#pragma mark - InfoViewInput

- (void) setupInitialStateWithVersion:(NSString *)version {
  switch ([UIScreen mainScreen].screenSizeType) {
    case ScreenSizeTypeInches35:
    case ScreenSizeTypeInches40: {
      self.versionTopOffsetConstraint.constant = 20.0;
    }
    case ScreenSizeTypeInches47: {
      self.titleTopOffsetConstraint.constant = 24.0;
      break;
    }
    default:
      break;
  }
  self.versionLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Version %@", @"Info screen. Version format"), version];
  NSInteger year = [[NSCalendar currentCalendar] component:NSCalendarUnitYear fromDate:[NSDate date]];
  if (kStartDevelopmentYear < year) {
    self.copyrightLabel.text = [NSString stringWithFormat:@"Copyright %zd-%zd MyEtherWallet Inc.", kStartDevelopmentYear, year];
  } else {
    self.copyrightLabel.text = [NSString stringWithFormat:@"Copyright %zd MyEtherWallet Inc.", kStartDevelopmentYear];
  }
  [self.dataDisplayManager updateDataDisplayManager];
  self.tableView.dataSource = [self.dataDisplayManager dataSourceForTableView:self.tableView];
  self.tableView.delegate = [self.dataDisplayManager delegateForTableView:self.tableView
                                                         withBaseDelegate:self.dataDisplayManager];
  [self _updatePrefferedContentSize];
}

- (void) presentResetConfirmation {
  UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"⚠️\nWarning: you can lose your account and funds forever", @"Info screen. Reset wallet alert")
                                                                 message:NSLocalizedString(@"Don't reset if you didn't make a backup, as there will be no way to restore your account after that. Resetting wallet will remove all keys saved in the local vault and bring you back to the app's start screen.", @"Info screen. Reset wallet alert")
                                                          preferredStyle:UIAlertControllerStyleAlert];
  [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"Info screen. Reset wallet alert")
                                            style:UIAlertActionStyleCancel
                                          handler:nil]];
  @weakify(self);
  [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Reset wallet", @"Info screen. Reset wallet alert")
                                            style:UIAlertActionStyleDestructive
                                          handler:^(__unused UIAlertAction * _Nonnull action) {
                                            @strongify(self);
                                            [self.output resetWalletConfirmedAction];
                                          }]];
  [self presentViewController:alert animated:YES completion:nil];
}

- (void) presentMailComposeWithSubject:(NSString *)subject recipients:(NSArray <NSString *> *)recipients {
  if ([MFMailComposeViewController canSendMail]) {
    MFMailComposeViewController *mailComposeViewController = [[MFMailComposeViewController alloc] init];
    [mailComposeViewController setSubject:subject];
    [mailComposeViewController setToRecipients:recipients];
    mailComposeViewController.mailComposeDelegate = self;
    [self presentViewController:mailComposeViewController animated:YES completion:nil];
  } else {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Error", @"Info screen. Contact")
                                                                   message:NSLocalizedString(@"Can't send email", @"Info screen. Contact")
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"Info screen. Contact") style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
  }
}

#pragma mark - IBActions

- (IBAction) closeAction:(__unused id)sender {
  [self.output closeAction];
}

- (IBAction) resetWalletAction:(__unused id)sender {
  [self.output resetWalletAction];
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

#pragma mark - InfoDataDisplayManagerDelegate

- (void) didTapContact {
  [self.output contactAction];
}

- (void) didTapKnowledgeBase {
  [self.output knowledgeBaseAction];
}

- (void) didTapPrivacyAndTerms {
  [self.output privacyAndTermsAction];
}

- (void) didTapMyEtherWalletCom {
  [self.output myEtherWalletComAction];
}

- (void) didTapResetWallet {
  [self.output resetWalletAction];
}

- (void) didTapUserGuide {
  [self.output userGuideAction];
}

- (void) didTapAbout {
  [self.output aboutAction];
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(__unused MFMailComposeViewController *)controller didFinishWithResult:(__unused MFMailComposeResult)result error:(nullable __unused NSError *)error {
  [self dismissViewControllerAnimated:YES completion:nil];
}

@end
