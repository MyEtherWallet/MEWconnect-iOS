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

#import "HomeTableViewAnimator.h"
#import "HomeDataDisplayManager.h"

#import "MasterTokenPlainObject.h"
#import "NetworkPlainObject.h"
#import "AccountPlainObject.h"

#import "TokenPlainObject.h"
#import "FiatPricePlainObject.h"

#import "HomeStretchyHeader.h"
#import "CardView.h"
#import "RotationButton.h"

#import "UIImage+Color.h"
#import "UIColor+Hex.h"
#import "UIColor+Application.h"
#import "UIScreen+ScreenSizeType.h"

#import "HomeTableViewAnimator.h"

#import "NSNumberFormatter+Ethereum.h"

static CGFloat kHomeViewControllerBottomDefaultOffset = 38.0;

@interface HomeViewController () <UIScrollViewDelegate, GSKStretchyHeaderViewStretchDelegate, HomeStretchyHeaderDelegate, CardViewDelegate, UISearchBarDelegate>
@property (nonatomic, weak) IBOutlet UIButton *connectButton;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) HomeStretchyHeader *headerView;
@property (nonatomic, strong) IBOutlet UIView *tableHeaderView;
@property (nonatomic) NSUInteger numberOfTokens;
@property (nonatomic, weak) IBOutlet UIImageView *statusBackgroundImageView;
@property (nonatomic, weak) IBOutlet UIView *statusView;
@property (nonatomic, weak) IBOutlet UILabel *statusLabel;
@property (nonatomic, weak) IBOutlet UIButton *disconnectButton;
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
  self.tableViewAnimator.animated = YES;
  
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
  
  self.tableViewAnimator.animated = NO;
  
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
  [self.headerView updateTitle:NSLocalizedString(@"MEWconnect", @"Home screen. Title")];
  self.headerView.searchBar.hidden = (tokensCount == 0);
  self.headerView.searchBar.placeholder = [NSString localizedStringWithFormat:NSLocalizedString(@"Search %tu token(s)", @"Wallet. Search field placeholder"), tokensCount];
  
  self.headerView.cardView.delegate = self;
  self.headerView.searchBar.delegate = self;
  
  [self.headerView.infoButton addTarget:self action:@selector(infoAction:) forControlEvents:UIControlEventTouchUpInside];
  [self.headerView.buyEtherButton addTarget:self action:@selector(buyEtherAction:) forControlEvents:UIControlEventTouchUpInside];
  [self.headerView.refreshButton addTarget:self action:@selector(refreshTokensAction:) forControlEvents:UIControlEventTouchUpInside];
  [self.headerView.networkButton addTarget:self action:@selector(networkAction:) forControlEvents:UIControlEventTouchUpInside];
  
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
                                          resizableImageWithCapInsets:UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)];
    [self.statusBackgroundImageView setImage:disconnectBackgroundImage];
  }
}

- (void)updateWithTransactionBatch:(CacheTransactionBatch *)transactionBatch {
  [self.dataDisplayManager updateDataDisplayManagerWithTransactionBatch:transactionBatch maximumCount:_numberOfTokens];
}

- (void) updateWithMasterToken:(MasterTokenPlainObject *)masterToken {
  if ([self isViewLoaded]) {
    NetworkPlainObject *network = masterToken.fromNetworkMaster;
    AccountPlainObject *account = network.fromAccount;
    
    BlockchainNetworkType networkType = [network network];
    [self.headerView.networkButton setTitle:NSStringFromBlockchainNetworkType(networkType) forState:UIControlStateNormal];
    [self.headerView.cardView updateWithSeed:masterToken.address];
    
    [self.headerView refreshContentIfNeeded];
    
    self.headerView.cardView.backedUp = [account.backedUp boolValue];
    [self updateBalanceWithMasterToken:masterToken];
  }
}

- (void) updateBalanceWithMasterToken:(MasterTokenPlainObject *)masterToken {
  NetworkPlainObject *network = masterToken.fromNetworkMaster;
  
  [self.headerView.cardView updateEthPrice:masterToken.price.usdPrice];
  
  NSNumberFormatter *ethereumFormatter = [NSNumberFormatter ethereumFormatterWithNetwork:[network network]];
  switch ([UIScreen mainScreen].screenSizeType) {
    case ScreenSizeTypeInches40: { ethereumFormatter.maximumSignificantDigits = 9; break; }
    case ScreenSizeTypeInches58:
    case ScreenSizeTypeInches47: { ethereumFormatter.maximumSignificantDigits = 15; break; }
    case ScreenSizeTypeInches55: { ethereumFormatter.maximumSignificantDigits = 19; break; }
    default:
      break;
  }
  
  NSDecimalNumber *balance = masterToken.amount;
  [self.headerView.cardView updateBalance:balance network:[network network]];
  self.headerView.titleBalanceLabel.text = [ethereumFormatter stringFromNumber:balance];
}

- (void) viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
  if (@available(iOS 11.0, *)) {
  } else {
    [self.headerView updateHeightIfNeeded];
  }
  [self _updateTableViewFooterIfNeeded];
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

- (void) startAnimatingRefreshing {
  self.headerView.refreshButton.rotation = YES;
}

- (void) stopAnimatingRefreshing {
  self.headerView.refreshButton.rotation = NO;
}

- (void)presentNetworkSelection {
  UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Select network", @"Wallet. Network selection") message:nil preferredStyle:UIAlertControllerStyleActionSheet];
  [alert addAction:[UIAlertAction actionWithTitle:@"Main Ethereum network"
                                            style:UIAlertActionStyleDefault
                                          handler:^(__unused UIAlertAction * _Nonnull action) {
    [self.output mainnetAction];
  }]];
  [alert addAction:[UIAlertAction actionWithTitle:@"Ropsten Test network"
                                            style:UIAlertActionStyleDefault
                                          handler:^(__unused UIAlertAction * _Nonnull action) {
    [self.output ropstenAction];
  }]];
  [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"Wallet. Network selection. Cancel")
                                            style:UIAlertActionStyleCancel
                                          handler:nil]];
  [self presentViewController:alert animated:YES completion:nil];
}

- (void)updateStatusWithInternetConnection:(BOOL)internetConnection mewConnectConnection:(BOOL)mewConnectConnection animated:(BOOL)animated {
  _connected = mewConnectConnection;
  @weakify(self);
  if (internetConnection) {
    if (mewConnectConnection) {
      self.connectButtonBottomConstraint.constant = -(CGRectGetHeight(self.connectButton.frame) + kHomeViewControllerBottomDefaultOffset + self.view.layoutMargins.bottom);
      UIImage *backgroundImage = [[UIImage imageWithColor:[UIColor mainApplicationColor]
                                                     size:CGSizeMake(20.0, 28.0)
                                             cornerRadius:8.0
                                                  corners:UIRectCornerTopLeft|UIRectCornerTopRight]
                                  resizableImageWithCapInsets:UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)];
      self.statusView.hidden = NO;
      self.statusView.alpha = 1.0;
      if (animated) {
        if (self.disconnectButton.hidden) {
          self.disconnectButton.hidden = NO;
          self.disconnectButton.alpha = 0.0;
          [self.animator addAnimations:^{
            @strongify(self);
            self.disconnectButton.alpha = 1.0;
          }];
        }
        [UIView transitionWithView:self.statusBackgroundImageView
                          duration:self.animator.duration
                           options:UIViewAnimationOptionTransitionCrossDissolve|UIViewAnimationOptionBeginFromCurrentState
                        animations:^{
                          [self.statusBackgroundImageView setImage:backgroundImage];
                        } completion:nil];
        [UIView transitionWithView:self.statusLabel
                          duration:self.animator.duration
                           options:UIViewAnimationOptionTransitionCrossDissolve|UIViewAnimationOptionBeginFromCurrentState
                        animations:^{
                          self.statusLabel.text = NSLocalizedString(@"Connected to MyEtherWallet", @"Wallet. MEWconnect connected status");
                        } completion:nil];
      } else {
        [self.statusBackgroundImageView setImage:backgroundImage];
        self.statusLabel.text = NSLocalizedString(@"Connected to MyEtherWallet", @"Wallet. MEWconnect connected status");
        self.disconnectButton.hidden = NO;
        self.disconnectButton.alpha = 1.0;
      }
      self.statusBottomContraint.constant = 0.0;
    } else {
      self.connectButtonBottomConstraint.constant = kHomeViewControllerBottomDefaultOffset;
      if (animated) {
        self.statusView.alpha = 1.0;
        [self.animator addCompletion:^(__unused UIViewAnimatingPosition finalPosition) {
          @strongify(self);
          self.statusView.alpha = 0.0;
          self.statusView.hidden = YES;
        }];
      } else {
        self.statusView.hidden = YES;
      }
      
      self.statusBottomContraint.constant = -(CGRectGetHeight(self.statusView.bounds));
    }
  } else {
    UIImage *backgroundImage = [[UIImage imageWithColor:[UIColor colorWithRGB:0xB6B9C1]
                                                   size:CGSizeMake(20.0, 28.0)
                                           cornerRadius:8.0
                                                corners:UIRectCornerTopLeft|UIRectCornerTopRight]
                                resizableImageWithCapInsets:UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)];
    if (animated) {
      [UIView transitionWithView:self.statusBackgroundImageView
                        duration:self.animator.duration
                         options:UIViewAnimationOptionTransitionCrossDissolve|UIViewAnimationOptionBeginFromCurrentState
                      animations:^{
                        [self.statusBackgroundImageView setImage:backgroundImage];
                      } completion:nil];
    } else {
      [self.statusBackgroundImageView setImage:backgroundImage];
    }
    
    self.statusView.hidden = NO;
    self.statusView.alpha = 1.0;
    self.statusBottomContraint.constant = 0.0;
    if (animated) {
      [UIView transitionWithView:self.statusLabel
                        duration:self.animator.duration
                         options:UIViewAnimationOptionTransitionCrossDissolve|UIViewAnimationOptionBeginFromCurrentState
                      animations:^{
                        self.statusLabel.text = NSLocalizedString(@"No internet connection", @"Wallet. No internet connection status");
                      } completion:nil];
      [self.animator addAnimations:^{
        @strongify(self);
        self.disconnectButton.alpha = 0.0;
      }];
      [self.animator addCompletion:^(__unused UIViewAnimatingPosition finalPosition) {
        @strongify(self);
        self.disconnectButton.hidden = YES;
        self.disconnectButton.alpha = 1.0;
      }];
    } else {
      self.statusLabel.text = NSLocalizedString(@"No internet connection", @"Wallet. No internet connection status");
      self.disconnectButton.hidden = YES;
    }
    if (mewConnectConnection) {
      self.connectButtonBottomConstraint.constant = -(CGRectGetHeight(self.connectButton.frame) + kHomeViewControllerBottomDefaultOffset + self.view.layoutMargins.bottom);
    } else {
      self.connectButtonBottomConstraint.constant = kHomeViewControllerBottomDefaultOffset;
    }
  }
  if (animated) {
    [self.animator addAnimations:^{
      @strongify(self);
      [self.view layoutIfNeeded];
    }];
    [self.animator addCompletion:^(__unused UIViewAnimatingPosition finalPosition) {
      @strongify(self);
      [self _updateTableViewInsets];
    }];
    [self.animator startAnimation];
  } else {
    [self.view layoutIfNeeded];
    [self _updateTableViewInsets];
  }
}

- (void) showInternetConnection {
  self.statusBottomContraint.constant = -(CGRectGetHeight(self.statusView.bounds));
}

- (void) showNoInternetConnection {
  self.statusView.hidden = NO;
  UIImage *disconnectBackgroundImage = [[UIImage imageWithColor:[UIColor colorWithRGB:0xB6B9C1]
                                                           size:CGSizeMake(20.0, 28.0)
                                                   cornerRadius:8.0
                                                        corners:UIRectCornerTopLeft|UIRectCornerTopRight]
                                        resizableImageWithCapInsets:UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)];
  [self.statusBackgroundImageView setImage:disconnectBackgroundImage];
  self.statusBottomContraint.constant = 0.0;
}

#pragma mark - IBActions

- (IBAction) connectAction:(__unused id)sender {
  [self.output connectAction];
}

- (IBAction) disconnectAction:(__unused id)sender {
  [self.output disconnectAction];
}

- (IBAction) infoAction:(__unused id)sender {
  [self.output infoAction];
}

- (IBAction) buyEtherAction:(__unused id)sender {
  [self.output buyEtherAction];
}

- (IBAction) refreshTokensAction:(__unused id)sender {
  [self.output refreshTokensAction];
}

- (IBAction) networkAction:(__unused id)sender {
  [self.output networkAction];
}

- (IBAction) unwindToHome:(__unused UIStoryboardSegue *)sender {}

#pragma mark - GSKStretchyHeaderViewStretchDelegate

- (void) stretchyHeaderView:(__unused GSKStretchyHeaderView *)headerView didChangeStretchFactor:(__unused CGFloat)stretchFactor {
}

#pragma mark - HomeStretchyHeaderDelegate

- (void) homeStretchyHeaderRequirinUpdateStatusBarStyle:(__unused HomeStretchyHeader *)strethyHeader {
  [UIView animateWithDuration:kHomeStretchyHeaderFadeDuration animations:^{
    [self setNeedsStatusBarAppearanceUpdate];
  }];
}

- (void) homeStretchyHeaderViewDidChangeBackgroundAlpha:(CGFloat)alpha {
  self.tableView.backgroundView.alpha = alpha;
}

#pragma mark - UIScrollViewDelegate

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
  CGPoint offset = scrollView.contentOffset;
  offset.y += self.headerView.minimumContentHeight;
  if (offset.y > 0.0) {
    self.headerView.searchBarStyle = HomeStretchyHeaderSearchBarStyleLightBlue;
  } else {
    self.headerView.searchBarStyle = HomeStretchyHeaderSearchBarStyleWhite;
  }
  UIEdgeInsets indicatorInset = self.tableView.scrollIndicatorInsets;
  indicatorInset.top = CGRectGetHeight(self.headerView.contentView.bounds);
  self.tableView.scrollIndicatorInsets = indicatorInset;
}

- (void) scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(__unused CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
  CGFloat fullSize = self.headerView.maximumContentHeight - self.headerView.minimumContentHeight;
  if ((*targetContentOffset).y < -self.headerView.minimumContentHeight) {
    if ((*targetContentOffset).y < -self.headerView.maximumContentHeight + fullSize * 0.65) {
      (*targetContentOffset).y = -scrollView.contentInset.top;
    } else {
      (*targetContentOffset).y = -self.headerView.minimumContentHeight;
    }
  }
}

#pragma mark - CardViewDelegate

- (void) cardViewDidTouchShareButton:(__unused CardView *)cardView {
  [self.output shareAction];
}

- (void) cardViewDidTouchBackupButton:(__unused CardView *)cardView {
  [self.output backupAction];
}

- (void) cardViewDidTouchBackupStatusButton:(__unused CardView *)cardView {
  
}

#pragma mark - UISearchBarDelegate

- (BOOL) searchBarShouldBeginEditing:(__unused UISearchBar *)searchBar {
  if ((self.tableView.contentOffset.y + self.headerView.minimumContentHeight) < 0.0) {
    CGPoint newContentOffset = CGPointMake(0.0, -self.headerView.minimumContentHeight);
    [self.tableView setContentOffset:newContentOffset animated:YES];
  }
  return YES;
}

- (void) searchBar:(__unused UISearchBar *)searchBar textDidChange:(NSString *)searchText {
  [self.output searchTermDidChanged:searchText];
}

#pragma mark - Notifications

- (void) keyboardWillShow:(NSNotification *)notification {
  CGSize keyboardSize = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
  _keyboardHeight = keyboardSize.height;
  [self _updateTableViewInsets];
}

- (void) keyboardWillHide:(__unused NSNotification *)notification {
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
  self.numberOfTokens > 0 ? CGRectGetHeight(self.connectButton.frame) + self.connectButtonBottomConstraint.constant : 0.0;
  insets.bottom = MAX(_keyboardHeight, statusHeight);
  
  self.tableView.contentInset = insets;
  
  UIEdgeInsets indicatorInset = self.tableView.scrollIndicatorInsets;
  indicatorInset.bottom = _keyboardHeight;
  self.tableView.scrollIndicatorInsets = indicatorInset;
  [self _updateTableViewFooterIfNeeded];
}

- (void) _updateTableViewFooterIfNeeded {
  CGFloat additionalHeight = CGRectGetHeight(self.view.frame) - (self.tableView.contentSize.height - CGRectGetHeight(self.tableView.tableFooterView.frame)) - self.headerView.minimumContentHeight - self.tableView.contentInset.bottom;
  if (additionalHeight > 0.0 && _numberOfTokens > 0) {
    if (CGRectGetHeight(self.tableView.tableFooterView.frame) != additionalHeight) {
      UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 1.0, additionalHeight)];
      footerView.backgroundColor = [UIColor clearColor];
      self.tableView.tableFooterView = footerView;
    }
  } else {
    self.tableView.tableFooterView = nil;
  }
}

@end
