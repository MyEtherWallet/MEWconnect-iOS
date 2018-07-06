//
//  HomeViewController.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import libextobjc.EXTScope;

#import "HomeViewController.h"

#import "HomeViewOutput.h"

#import "HomeDataDisplayManager.h"

#import "AccountPlainObject.h"
#import "NetworkPlainObject.h"
#import "TokenPlainObject.h"
#import "FiatPricePlainObject.h"

#import "HomeStretchyHeader.h"
#import "CardView.h"

#import "UIImage+Color.h"
#import "UIColor+Hex.h"
#import "UIColor+Application.h"

#import "HomeTableViewAnimator.h"

#import "NSNumberFormatter+Ethereum.h"

static CGFloat kHomeViewControllerBottomDefaultOffset = 16.0;

@interface HomeViewController () <UIScrollViewDelegate, GSKStretchyHeaderViewStretchDelegate, HomeStretchyHeaderDelegate, CardViewDelegate, UISearchBarDelegate>
@property (nonatomic, weak) IBOutlet UIButton *connectButton;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) HomeStretchyHeader *headerView;
@property (nonatomic, strong) IBOutlet UIView *tableHeaderView;
@property (nonatomic) NSUInteger numberOfTokens;
@property (nonatomic, weak) IBOutlet UIImageView *statusBackgroundImageView;
@property (nonatomic, strong) IBOutlet UIView *statusView;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *statusBottomContraint;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *connectButtonBottomConstraint;
@end

@implementation HomeViewController {
  CGFloat _keyboardHeight;
  BOOL _connected;
}

#pragma mark - LifeCycle

- (void)viewDidLoad {
	[super viewDidLoad];

	[self.output didTriggerViewReadyEvent];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.output didTriggerViewWillAppear];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  /* Fix GSKStretchyHeaderView issue: [UIScrollView gsk_fixZPositionsForStretchyHeaderView:]; */
  self.tableView.backgroundView.layer.zPosition = 0.0;
}

- (void) viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
  
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  
  [self.output didTriggerViewDidDisappear];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
  return [self.headerView preferredStatusBarStyle];
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
  return UIStatusBarAnimationFade;
}

- (void)viewSafeAreaInsetsDidChange {
  [super viewSafeAreaInsetsDidChange];
  if (@available(iOS 11.0, *)) {
    [self.headerView updateHeightIfNeeded];
  }
  [self _updateTableViewInsets];
}

#pragma mark - HomeViewInput

- (void) setupInitialStateWithNumberOfTokens:(NSUInteger)tokensCount totalPrice:(NSDecimalNumber *)totalPrice {
  if (@available(iOS 11.0, *)) {
    self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
  }
  HomeStretchyHeader *header = [[HomeStretchyHeader alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(self.view.frame), 308.0) delegate:self];
  header.stretchDelegate = self;
  
  [header refreshContentIfNeeded];
  [self.tableView addSubview:header];
  _headerView = header;
  
  _numberOfTokens = tokensCount;
  [self.headerView updateTokensPrice:totalPrice];
  self.headerView.searchBar.hidden = (tokensCount == 0);
  self.headerView.searchBar.placeholder = [NSString localizedStringWithFormat:NSLocalizedString(@"Search %tu token(s)", @"Wallet. Search field placeholder"), tokensCount];
  
  self.headerView.cardView.delegate = self;
  self.headerView.searchBar.delegate = self;
  
  [self.headerView.infoButton addTarget:self action:@selector(infoAction:) forControlEvents:UIControlEventTouchUpInside];
  [self.headerView.buyEtherButton addTarget:self action:@selector(buyEtherAction:) forControlEvents:UIControlEventTouchUpInside];
  
  [self.dataDisplayManager configureDataDisplayManagerWithAnimator:self.tableViewAnimator];
  self.tableView.dataSource = [self.dataDisplayManager dataSourceForTableView:self.tableView];
  self.tableView.delegate = [self.dataDisplayManager delegateForTableView:self.tableView
                                                         withBaseDelegate:self.dataDisplayManager];
  UIView *tableViewBackgroundView = [[UIView alloc] init];
  tableViewBackgroundView.backgroundColor = [UIColor whiteColor];
  tableViewBackgroundView.alpha = 0.0;
  self.tableView.backgroundView = tableViewBackgroundView;
  self.tableViewAnimator.tableView = self.tableView;
  
  { //Scan button
    UIImage *scanBackgroundImage = [[UIImage imageWithColor:[UIColor mainApplicationColor]
                                                       size:CGSizeMake(52.0, 52.0)
                                               cornerRadius:26.0] resizableImageWithCapInsets:UIEdgeInsetsMake(26.0, 26.0, 26.0, 26.0)];
    [self.connectButton setBackgroundImage:scanBackgroundImage forState:UIControlStateNormal];
    self.connectButton.layer.shadowColor = [UIColor mainApplicationColor].CGColor;
    self.connectButton.layer.shadowOffset = CGSizeMake(0.0, 2.0);
    self.connectButton.layer.shadowRadius = 6.0;
    self.connectButton.layer.shadowOpacity = 0.2;
    
    NSDictionary *attributes = @{NSFontAttributeName: self.connectButton.titleLabel.font,
                                 NSForegroundColorAttributeName: [self.connectButton titleColorForState:UIControlStateNormal],
                                 NSKernAttributeName: @(0.6)};
    [self.connectButton setAttributedTitle:[[NSAttributedString alloc] initWithString:[self.connectButton titleForState:UIControlStateNormal]
                                                                           attributes:attributes]
                                                                             forState:UIControlStateNormal];
  }
  {
    UIImage *disconnectBackgroundImage = [[UIImage imageWithColor:[UIColor mainApplicationColor]
                                                             size:CGSizeMake(20.0, 28.0)
                                                     cornerRadius:8.0
                                                          corners:UIRectCornerTopLeft|UIRectCornerTopRight]
                                          resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 10.0, 0.0, 10.0)];
    [self.statusBackgroundImageView setImage:disconnectBackgroundImage];
  }
}

- (void)updateWithTransactionBatch:(CacheTransactionBatch *)transactionBatch {
  [self.dataDisplayManager updateDataDisplayManagerWithTransactionBatch:transactionBatch maximumCount:_numberOfTokens];
}

- (void)updateWithAccount:(AccountPlainObject *)account {
  switch ([account.fromNetwork network]) {
    case BlockchainNetworkTypeRopsten: {
      [self.headerView updateTitle:NSLocalizedString(@"MEWconnect: Ropsten", @"Home screen. Title")];
      break;
    }
    case BlockchainNetworkTypeMainnet:
    default: {
      [self.headerView updateTitle:NSLocalizedString(@"MEWconnect", @"Home screen. Title")];
      break;
    }
  }
  [self.headerView.cardView updateWithSeed:account.publicAddress];
  [self.headerView.cardView updateEthPrice:account.price.usdPrice];
  [self.headerView refreshContentIfNeeded];
  
  self.headerView.cardView.backedUp = [account.backedUp boolValue];
  
  NSDecimalNumber *balance = account.balance;
  [self.headerView.cardView updateBalance:balance network:[account.fromNetwork network]];
  
  NSNumberFormatter *ethereumFormatter = [NSNumberFormatter ethereumFormatterWithNetwork:[account.fromNetwork network]];
  self.headerView.titleBalanceLabel.text = [ethereumFormatter stringFromNumber:balance];
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
  if (@available(iOS 11.0, *)) {
  } else {
    [self.headerView updateHeightIfNeeded];
  }
}

- (void) updateWithTokensCount:(NSUInteger)tokensCount withTotalPrice:(NSDecimalNumber *)totalPrice {
  [self.headerView updateTokensPrice:totalPrice];
  _numberOfTokens = tokensCount;
  if (_numberOfTokens > 0) {
    self.headerView.searchBar.placeholder = [NSString localizedStringWithFormat:NSLocalizedString(@"Search %tu token(s)", @"Wallet. Search field placeholder"), tokensCount];
    self.headerView.searchBar.hidden = NO;
  } else {
    self.headerView.searchBar.hidden = YES;
    [self.dataDisplayManager updateDataDisplayManagerWithTransactionBatch:nil maximumCount:0];
  }
}

- (void) updateWithConnectionStatus:(BOOL)connected animated:(BOOL)animated {
  _connected = connected;
  if (connected) {
    self.statusBottomContraint.constant = -(CGRectGetHeight(self.statusView.bounds));
    [self.view layoutIfNeeded];
    self.connectButtonBottomConstraint.constant = -(CGRectGetHeight(self.connectButton.frame) + kHomeViewControllerBottomDefaultOffset + self.view.layoutMargins.bottom);
    self.statusBottomContraint.constant = 0.0;
    self.statusView.hidden = NO;
    if (animated) {
      [UIView animateWithDuration:0.3
                       animations:^{
                         [self.view layoutIfNeeded];
                       } completion:^(BOOL finished) {
                         self.connectButton.hidden = YES;
                       }];
    } else {
      [self.view layoutIfNeeded];
      self.connectButton.hidden = YES;
    }
  } else {
    self.connectButtonBottomConstraint.constant = kHomeViewControllerBottomDefaultOffset;
    self.statusBottomContraint.constant = -(CGRectGetHeight(self.statusView.bounds));
    self.connectButton.hidden = NO;
    if (animated) {
      [UIView animateWithDuration:0.3
                       animations:^{
                         [self.view layoutIfNeeded];
                       } completion:^(BOOL finished) {
                         self.statusView.hidden = YES;
                       }];
    } else {
      [self.view layoutIfNeeded];
      self.statusView.hidden = YES;
    }
  }
  [self _updateTableViewInsets];
}

- (void) presentShareWithItems:(NSArray *)items {
  UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];
  [self presentViewController:activityController animated:YES completion:nil];
}

#pragma mark - IBActions

- (IBAction) connectAction:(id)sender {
  [self.output connectAction];
}

- (IBAction) disconnectAction:(id)sender {
  [self.output disconnectAction];
}

- (IBAction) infoAction:(id)sender {
  [self.output infoAction];
}

- (IBAction) buyEtherAction:(id)sender {
  [self.output buyEtherAction];
}

- (IBAction)unwindToHome:(UIStoryboardSegue *)sender {}

#pragma mark - GSKStretchyHeaderViewStretchDelegate

- (void)stretchyHeaderView:(GSKStretchyHeaderView *)headerView didChangeStretchFactor:(CGFloat)stretchFactor {
}

#pragma mark - HomeStretchyHeaderDelegate

- (void)homeStretchyHeaderRequirinUpdateStatusBarStyle:(HomeStretchyHeader *)strethyHeader {
  [UIView animateWithDuration:kHomeStretchyHeaderFadeDuration animations:^{
    [self setNeedsStatusBarAppearanceUpdate];
  }];
}

- (void)homeStretchyHeaderViewDidChangeBackgroundAlpha:(CGFloat)alpha {
  self.tableView.backgroundView.alpha = alpha;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  CGPoint offset = scrollView.contentOffset;
  offset.y += self.headerView.minimumContentHeight;
  if (offset.y > 0.0) {
    self.headerView.searchBarStyle = HomeStretchyHeaderSearchBarStyleLightBlue;
  } else {
    self.headerView.searchBarStyle = HomeStretchyHeaderSearchBarStyleWhite;
  }
}

#pragma mark - CardViewDelegate

- (void)cardViewDidTouchShareButton:(CardView *)cardView {
  [self.output shareAction];
}

- (void)cardViewDidTouchBackupButton:(CardView *)cardView {
  [self.output backupAction];
}

- (void)cardViewDidTouchBackupStatusButton:(CardView *)cardView {
  
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
  [self.output searchTermDidChanged:searchText];
}

#pragma mark - Notifications

- (void) keyboardWillShow:(NSNotification *)notification {
  CGSize keyboardSize = [notification.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
  _keyboardHeight = keyboardSize.height;
  [self _updateTableViewInsets];
}

- (void) keyboardWillHide:(NSNotification *)notification {
  _keyboardHeight = 0.0;
  [self _updateTableViewInsets];
}

#pragma mark - Private

- (void) _updateTableViewInsets {
  UIEdgeInsets insets;
  if (@available(iOS 11.0, *)) {
    insets = self.tableView.adjustedContentInset;
  } else {
    insets = self.tableView.contentInset;
  }
  CGFloat statusHeight = _connected ?
      CGRectGetHeight(self.statusView.frame) :
      CGRectGetHeight(self.connectButton.frame) + self.connectButtonBottomConstraint.constant;
  insets.bottom = MAX(_keyboardHeight, statusHeight);
  
  self.tableView.contentInset = insets;
  
  UIEdgeInsets indicatorInset = self.tableView.scrollIndicatorInsets;
  indicatorInset.bottom = _keyboardHeight;
  self.tableView.scrollIndicatorInsets = indicatorInset;
}

@end
