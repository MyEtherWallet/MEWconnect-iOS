//
//  InfoViewController.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 24/06/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import libextobjc.EXTScope;

#import "InfoViewController.h"

#import "InfoViewOutput.h"

#import "InfoDataDisplayManager.h"

#import "ApplicationConstants.h"

#import "NSBundle+Version.h"

@interface InfoViewController () <InfoDataDisplayManagerDelegate>
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UILabel *versionLabel;
@property (nonatomic, weak) IBOutlet UILabel *copyrightLabel;
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

- (void) setupInitialState {
  self.versionLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Version %@", @"Info screen. Version format"), [[NSBundle mainBundle] applicationVersion]];
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
  UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(changeNetworkAction:)];
  longPressGesture.minimumPressDuration = 7.0;
  longPressGesture.numberOfTouchesRequired = 2;
  [self.copyrightLabel addGestureRecognizer:longPressGesture];
  self.copyrightLabel.userInteractionEnabled = YES;
}

- (void) presentResetConfirmation {
  UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"⚠️\nWarning: you can loose your account and funds forever", @"Info screen. Reset wallet alert")
                                                                 message:NSLocalizedString(@"Don't reset if you didn't make a backup, as there will be no way to restore your account after that. Resetting wallet will remove all keys saved in the local vault and bring you back to the app's start screen.", @"Info screen. Reset wallet alert")
                                                          preferredStyle:UIAlertControllerStyleAlert];
  [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"Info screen. Reset wallet alert") style:UIAlertActionStyleCancel handler:nil]];
  @weakify(self);
  [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Reset wallet", @"Info screen. Reset wallet alert") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
    @strongify(self);
    [self.output resetWalletConfirmedAction];
  }]];
  [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - IBActions

- (IBAction) closeAction:(id)sender {
  [self.output closeAction];
}

- (IBAction) changeNetworkAction:(UILongPressGestureRecognizer *)sender {
  if (sender.state == UIGestureRecognizerStateBegan) {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Network?", @"Open Easter Egg :)") message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"Mainnet" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
      [self.output mainnetAction];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Ropsten" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
      [self.output ropstenAction];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
  }
}

#pragma mark - Private

- (void) _updatePrefferedContentSize {
  CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
  CGRect bounds = self.view.window.bounds;
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

@end
