//
//  HomeStretchyHeader.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 11/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "HomeStretchyHeader.h"

#import "CardView.h"
#import "MEWSearchBar.h"
#import "RotationButton.h"
#import "InlineButton.h"

#import "UIImage+Color.h"
#import "UIColor+Hex.h"
#import "UIColor+Application.h"
#import "UIScreen+ScreenSizeType.h"

#import "NSNumberFormatter+USD.h"

typedef NS_ENUM(NSInteger, HomeStretchyHeaderStyle) {
  HomeStretchyHeaderStyleDefault,
  HomeStretchyHeaderStyleLightContent,
};

static CGFloat const kHomeStretchyHeaderMinimumContentHeight            = 130.0;
static CGFloat const kHomeStretchyHeaderMaximumContentHeight            = 176.0;
static CGFloat const kHomeStretchyHeaderMaximumContentHeight40Inches    = 172.0;

NSTimeInterval const kHomeStretchyHeaderFadeDuration                    = 0.2;

static CGFloat const kHomeStretchyHeaderDefaultOffset                   = 16.0;
static CGFloat const kHomeStretchyHeaderTopDefaultOffset                = 48.0;

static CGFloat const kHomeStretchyHeaderTitleTopMinOffset               = 6.0;
static CGFloat const kHomeStretchyHeaderTitleTopMaxOffset               = 9.0; //14

static CGFloat const kHomeStretchyHeaderMinSearchBarHeight              = 82.0;
static CGFloat const kHomeStretchyHeaderMaxSearchBarHeight              = 104.0;

static CGFloat const kHomeStretchyHeaderTokensTitleMinFontSize          = 17.0;
static CGFloat const kHomeStretchyHeaderTokensTitleMaxFontSize          = 22.0;

static CGFloat const kHomeStretchyHeaderTokensTitleTopMinOffset         = 14.0;
static CGFloat const kHomeStretchyHeaderTokensTitleTopMaxOffset         = 17.0;
static CGFloat const kHomeStretchyHeaderTokensTitleTopMaxOffset40Inches = 19.0;

static CGFloat const kHomeStretchyHeaderSearchBarHOffset                = 8.0;
static CGFloat const kHomeStretchyHeaderSearchBarHOffset40Inches        = 6.0;
static CGFloat const kHomeStretchyHeaderSearchBarBMinOffset             = 0.0;
static CGFloat const kHomeStretchyHeaderSearchBarBMaxOffset             = 8.0;

static CGFloat const kHomeStretchyHeaderNetworkButtonMinScale           = 0.8;
static CGFloat const kHomeStretchyHeaderNetworkButtonMaxScale           = 1.0;

static CGFloat const kHomeStretcyHeaderTitleBalanceTopMinOffset         = 0.0;
static CGFloat const kHomeStretcyHeaderTitleBalanceTopMaxOffset         = 26.0;

@interface HomeStretchyHeader ()
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UIButton *networkButton;
@property (nonatomic, strong) NSLayoutConstraint *titleLabelTopConstraint;

@property (nonatomic, weak) UIImageView *patternImageView;
@property (nonatomic, strong) NSLayoutConstraint *cardLeftConstraint;
@property (nonatomic, strong) NSLayoutConstraint *cardRightConstraint;
@property (nonatomic, strong) NSLayoutConstraint *cardTopConstraint;

@property (nonatomic, strong) NSLayoutConstraint *searchBarContainerHeightConstraints;
@property (nonatomic, strong) NSLayoutConstraint *tokenBalancesTitleTopConstraints;
@property (nonatomic, strong) NSLayoutConstraint *tokenBalancesTopConstraints;
@property (nonatomic, strong) NSLayoutConstraint *searchBarBottomConstraint;
@property (nonatomic, strong) NSLayoutConstraint *networkButtonTopConstraint;
@property (nonatomic, strong) NSLayoutConstraint *titleBalanceLabelTopConstraint;
@property (nonatomic, weak) UIImageView *searchBarBackgroundImageView;
@property (nonatomic, weak) UILabel *tokenBalancesTitleLabel;
@property (nonatomic, weak) UILabel *tokenBalancesLabel;
@property (nonatomic, weak) RotationButton *refreshButton;

@property (nonatomic) HomeStretchyHeaderStyle contentStyle;
@property (nonatomic) UIStatusBarStyle statusBarStyle;
#if BETA
@property (nonatomic, weak) UIImageView *betaIconImageView;
#endif
@end

@implementation HomeStretchyHeader {
  CGFloat _safeHeight;
  CGFloat _tokensTitleTopMaxOffset;
}

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<HomeStretchyHeaderDelegate>)delegate {
  self = [super initWithFrame:frame];
  if (self) {
    _delegate = delegate;
    [self _commonInit];
    _safeHeight = -1.0;
    [self updateHeightIfNeeded];
    self.backgroundColor = [UIColor applicationLightBlue];
  }
  return self;
}

#pragma mark - Public

- (void) refreshContentIfNeeded {
  self.patternImageView.image = self.cardView.backgroundImage;
}

- (UIStatusBarStyle) preferredStatusBarStyle {
  return self.statusBarStyle;
}

- (void) updateHeightIfNeeded {
  id <UILayoutSupport> topLayoutGuide = self.delegate.topLayoutGuide;
  if (_safeHeight != topLayoutGuide.length) {
    CGFloat oldSafeHeight = _safeHeight;
    _safeHeight = topLayoutGuide.length;
    self.minimumContentHeight = kHomeStretchyHeaderMinimumContentHeight + _safeHeight;
    CGFloat height = kHomeStretchyHeaderMaximumContentHeight;
    if ([UIScreen mainScreen].screenSizeType == ScreenSizeTypeInches40) {
      height = kHomeStretchyHeaderMaximumContentHeight40Inches;
    }
    CGFloat newHeight = height + self.cardView.intrinsicContentSize.height + _safeHeight;
    [self setMaximumContentHeight:newHeight resetAnimated:NO];
    if (self.cardTopConstraint.constant == kHomeStretchyHeaderTopDefaultOffset + oldSafeHeight) {
      self.cardTopConstraint.constant = kHomeStretchyHeaderTopDefaultOffset + _safeHeight;
    }
  }
}

- (void)setSearchBarStyle:(HomeStretchyHeaderSearchBarStyle)searchBarStyle {
  if (_searchBarStyle != searchBarStyle) {
    _searchBarStyle = searchBarStyle;
    UIColor *color = nil;
    switch (searchBarStyle) {
      case HomeStretchyHeaderSearchBarStyleLightBlue: {
        color = [UIColor applicationLightBlue];
        break;
      }
      case HomeStretchyHeaderSearchBarStyleWhite:
      default: {
        color = [UIColor whiteColor];
        break;
      }
    }
    self.searchBarBackgroundImageView.tintColor = color;
  }
}

- (void) updateTitle:(NSString *)title {
  self.titleLabel.text = title;
}

- (void) updateTokensPrice:(NSDecimalNumber *)price {
  NSNumberFormatter *usdFormatter = [NSNumberFormatter usdFormatter];
  self.tokenBalancesLabel.text = [usdFormatter stringFromNumber:price];
}

#pragma mark - Private

- (void) _commonInit {
  CardView *cardView = [[CardView alloc] init];
  {
    cardView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:cardView];
    
    NSDictionary *metrics = @{@"LOFFSET": @(kHomeStretchyHeaderDefaultOffset),
                              @"ROFFSET": @(kHomeStretchyHeaderDefaultOffset)};
    NSDictionary *views = @{@"card": cardView};
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(LOFFSET)-[card]-(ROFFSET)-|" options:NSLayoutFormatDirectionLeftToRight metrics:metrics views:views]];
    self.cardTopConstraint = [NSLayoutConstraint constraintWithItem:cardView attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.contentView attribute:NSLayoutAttributeTop
                                                         multiplier:1.0 constant:kHomeStretchyHeaderTopDefaultOffset + _safeHeight];
    [self.contentView addConstraint:self.cardTopConstraint];
    _cardView = cardView;
  }
  UIImageView *imageView = [[UIImageView alloc] init];
  {
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    imageView.contentMode = UIViewContentModeCenter;
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = kCardViewDefaultCornerRadius;
    imageView.layer.shouldRasterize = YES;
    imageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
    [self.contentView addSubview:imageView];
    [self.contentView sendSubviewToBack:imageView];
    
    self.cardLeftConstraint = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeLeft
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self.contentView attribute:NSLayoutAttributeLeft
                                                          multiplier:1.0 constant:kHomeStretchyHeaderDefaultOffset];
    self.cardRightConstraint = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeRight
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:imageView attribute:NSLayoutAttributeRight
                                                           multiplier:1.0 constant:kHomeStretchyHeaderDefaultOffset];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:cardView attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:imageView attribute:NSLayoutAttributeTop
                                                                multiplier:1.0 constant:0.0]];
    [self.contentView addConstraints:@[self.cardLeftConstraint, self.cardRightConstraint]];
    self.patternImageView = imageView;
  }
  UILabel *titleLabel = [[UILabel alloc] init];
  {
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.textColor = [UIColor darkTextColor];
    titleLabel.font = [UIFont systemFontOfSize:17.0 weight:UIFontWeightBold];
    [self.contentView addSubview:titleLabel];
    NSLayoutConstraint *centerXConstraint = [titleLabel.centerXAnchor constraintEqualToAnchor:self.contentView.centerXAnchor];
#if BETA
    centerXConstraint.priority = UILayoutPriorityDefaultHigh;
#endif
    centerXConstraint.active = YES;
    self.titleLabelTopConstraint = [titleLabel.topAnchor constraintEqualToAnchor:self.delegate.topLayoutGuide.bottomAnchor constant:kHomeStretchyHeaderTitleTopMinOffset];
    self.titleLabel = titleLabel;
  }
  UIButton *networkButton = [InlineButton inlineButtonWithChevron:YES];
  {
    networkButton.translatesAutoresizingMaskIntoConstraints = NO;
    networkButton.tintColor = [UIColor lightGreyTextColor];
    [networkButton setTitleColor:[UIColor lightGreyTextColor] forState:UIControlStateNormal];
    networkButton.titleLabel.font = [UIFont systemFontOfSize:11.0 weight:UIFontWeightMedium];
    [networkButton setContentEdgeInsets:UIEdgeInsetsMake(17.0, 0.0, 0.0, 0.0)];
    [networkButton setImageEdgeInsets:UIEdgeInsetsMake(0.0, 1.0, 0.0, 0.0)];
    [networkButton setImage:[UIImage imageNamed:@"inline_bottom_chevron"] forState:UIControlStateNormal];
    [self.contentView addSubview:networkButton];
    [networkButton.centerXAnchor constraintEqualToAnchor:self.titleLabel.centerXAnchor].active = YES;
    self.networkButtonTopConstraint = [networkButton.topAnchor constraintEqualToAnchor:self.titleLabel.topAnchor];
    self.networkButtonTopConstraint.active = YES;
    NSLayoutConstraint *widthConstraint = [networkButton.widthAnchor constraintEqualToAnchor:self.titleLabel.widthAnchor multiplier:1.0];
    widthConstraint.priority = UILayoutPriorityDefaultHigh;
    widthConstraint.active = YES;
    self.networkButton = networkButton;
  }
  UILabel *titleBalanceLabel = [[UILabel alloc] init];
  {
    titleBalanceLabel.alpha = 0.0;
    titleBalanceLabel.translatesAutoresizingMaskIntoConstraints = NO;
    titleBalanceLabel.textColor = [UIColor colorWithRGB:0xCCCCCC];
    titleBalanceLabel.font = [UIFont systemFontOfSize:13.0 weight:UIFontWeightSemibold];
    titleBalanceLabel.text = @"0.00 ETH";
    [self.contentView addSubview:titleBalanceLabel];
    [titleLabel.centerXAnchor constraintEqualToAnchor:titleBalanceLabel.centerXAnchor].active = YES;
    self.titleBalanceLabelTopConstraint = [titleBalanceLabel.topAnchor constraintEqualToAnchor:titleLabel.bottomAnchor constant:0.0];
    self.titleBalanceLabelTopConstraint.active = YES;
    _titleBalanceLabel = titleBalanceLabel;
  }
  UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeSystem];
  {
    infoButton.translatesAutoresizingMaskIntoConstraints = NO;
    [infoButton setImage:[UIImage imageNamed:@"i_icon"] forState:UIControlStateNormal];
    infoButton.tintColor = [[UIColor mainApplicationColor] colorWithAlphaComponent:0.1];
    [infoButton setContentEdgeInsets:UIEdgeInsetsMake(4.0, 4.0, 4.0, 4.0)];
    UIImage *backgroundImage = [[[UIImage imageWithColor:[UIColor blackColor] size:CGSizeMake(28.0, 28.0) cornerRadius:10.0 insets:UIEdgeInsetsMake(4.0, 4.0, 4.0, 4.0)] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 14.0, 0.0, 14.0)] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [infoButton setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    [self.contentView addSubview:infoButton];
    [infoButton.leftAnchor constraintEqualToAnchor:self.contentView.leftAnchor constant:kHomeStretchyHeaderDefaultOffset].active = YES;
    _infoButton = infoButton;
  }
  UIButton *buyEtherButton = [UIButton buttonWithType:UIButtonTypeSystem];
  {
    buyEtherButton.translatesAutoresizingMaskIntoConstraints = NO;
    [buyEtherButton setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    UIImage *backgroundImage = [[[UIImage imageWithColor:[UIColor blackColor] size:CGSizeMake(28.0, 28.0) cornerRadius:10.0 insets:UIEdgeInsetsMake(4.0, 4.0, 4.0, 4.0)] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 14.0, 0.0, 14.0)] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [buyEtherButton setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    NSString *title = NSLocalizedString(@"BUY ETHER", @"Home screen. Buy ether button title");
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:11.0 weight:UIFontWeightSemibold],
                                 NSForegroundColorAttributeName: [UIColor mainApplicationColor],
                                 NSKernAttributeName: @0.3};
    NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attributes];
    [buyEtherButton setAttributedTitle:attributedTitle forState:UIControlStateNormal];
    buyEtherButton.tintColor = [[UIColor mainApplicationColor] colorWithAlphaComponent:0.1];
    [buyEtherButton setContentEdgeInsets:UIEdgeInsetsMake(0.0, 12.0, 0.0, 12.0)];
    [self.contentView addSubview:buyEtherButton];
    [self.contentView.rightAnchor constraintEqualToAnchor:buyEtherButton.rightAnchor constant:kHomeStretchyHeaderDefaultOffset].active = YES;
    _buyEtherButton = buyEtherButton;
  }
#if BETA
  {
    UIImageView *betaIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"beta_icon"]];
    betaIcon.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:betaIcon];
    [betaIcon setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [titleLabel.rightAnchor constraintEqualToAnchor:betaIcon.leftAnchor constant:1.0].active = YES;
    [titleLabel.topAnchor constraintEqualToAnchor:betaIcon.centerYAnchor constant:-1.0].active = YES;
    [buyEtherButton.leftAnchor constraintGreaterThanOrEqualToAnchor:betaIcon.rightAnchor].active = YES;
    self.betaIconImageView = betaIcon;
  }
#endif
  UIView *searchBarContainerView = [[UIView alloc] init];
  {
    searchBarContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    searchBarContainerView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:searchBarContainerView];
    
    self.searchBarContainerHeightConstraints = [NSLayoutConstraint constraintWithItem:searchBarContainerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual
                                                                               toItem:nil attribute:NSLayoutAttributeNotAnAttribute
                                                                           multiplier:1.0 constant:104.0];
    [searchBarContainerView addConstraint:self.searchBarContainerHeightConstraints];
    NSDictionary *views = @{@"searchContainer": searchBarContainerView};
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[searchContainer]|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[searchContainer]|" options:0 metrics:nil views:views]];
    {
      UIImage *backgroundImage = [[UIImage imageWithColor:[UIColor blackColor] size:CGSizeMake(40.0, 40.0) cornerRadius:16.0 corners:UIRectCornerTopLeft | UIRectCornerTopRight]
                                  stretchableImageWithLeftCapWidth:20 topCapHeight:30];
      backgroundImage = [backgroundImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
      UIImageView *searchBarBackgroundImageView = [[UIImageView alloc] initWithImage:backgroundImage];
      searchBarBackgroundImageView.translatesAutoresizingMaskIntoConstraints = NO;
      searchBarBackgroundImageView.alpha = 0.0;
      searchBarBackgroundImageView.tintColor = [UIColor whiteColor];
      [searchBarContainerView addSubview:searchBarBackgroundImageView];
      NSDictionary *views = @{@"background":searchBarBackgroundImageView};
      [searchBarContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[background]|" options:0 metrics:nil views:views]];
      [searchBarContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[background]|" options:0 metrics:nil views:views]];
      
      self.searchBarBackgroundImageView = searchBarBackgroundImageView;
    }
    {
      UILabel *tokenBalancesTitle = [[UILabel alloc] init];
      tokenBalancesTitle.translatesAutoresizingMaskIntoConstraints = NO;
      tokenBalancesTitle.font = [UIFont systemFontOfSize:kHomeStretchyHeaderTokensTitleMaxFontSize weight:UIFontWeightBold];
      tokenBalancesTitle.textColor = [UIColor darkTextColor];
      tokenBalancesTitle.text = NSLocalizedString(@"Tokens", @"Home screen. Header");
      [searchBarContainerView addSubview:tokenBalancesTitle];
      [searchBarContainerView addConstraint:[NSLayoutConstraint constraintWithItem:tokenBalancesTitle attribute:NSLayoutAttributeLeading
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:searchBarContainerView attribute:NSLayoutAttributeLeading
                                                                        multiplier:1.0 constant:kHomeStretchyHeaderDefaultOffset]];
      _tokensTitleTopMaxOffset = kHomeStretchyHeaderTokensTitleTopMaxOffset;
      if ([UIScreen mainScreen].screenSizeType == ScreenSizeTypeInches40) {
        _tokensTitleTopMaxOffset = kHomeStretchyHeaderTokensTitleTopMaxOffset40Inches;
      }
      self.tokenBalancesTitleTopConstraints = [NSLayoutConstraint constraintWithItem:tokenBalancesTitle attribute:NSLayoutAttributeTop
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:searchBarContainerView attribute:NSLayoutAttributeTop
                                                                          multiplier:1.0 constant:_tokensTitleTopMaxOffset];
      [searchBarContainerView addConstraint:self.tokenBalancesTitleTopConstraints];
      self.tokenBalancesTitleLabel = tokenBalancesTitle;
    }
    { //Refresh button
      RotationButton *button = [RotationButton buttonWithType:UIButtonTypeSystem];
      button.translatesAutoresizingMaskIntoConstraints = NO;
      [button setContentEdgeInsets:UIEdgeInsetsMake(2.0, 2.0, 2.0, 2.0)];
      [button setImage:[UIImage imageNamed:@"refresh_icon"] forState:UIControlStateNormal];
      button.tintColor = [UIColor mainApplicationColor];
      [searchBarContainerView addSubview:button];
      [button.centerYAnchor constraintEqualToAnchor:self.tokenBalancesTitleLabel.centerYAnchor].active = YES;
      [button.leadingAnchor constraintEqualToAnchor:self.tokenBalancesTitleLabel.trailingAnchor constant:8.0].active = YES;
      
      _refreshButton = button;
    }
    {
      UILabel *tokenBalancesLabel = [[UILabel alloc] init];
      tokenBalancesLabel.translatesAutoresizingMaskIntoConstraints = NO;
      tokenBalancesLabel.font = [UIFont systemFontOfSize:kHomeStretchyHeaderTokensTitleMaxFontSize weight:UIFontWeightRegular];
      tokenBalancesLabel.textColor = [UIColor colorWithRGB:0x6D7372];
      NSNumberFormatter *usdFormatter = [NSNumberFormatter usdFormatter];
      tokenBalancesLabel.text = [usdFormatter stringFromNumber:@0];
      [searchBarContainerView addSubview:tokenBalancesLabel];
      [searchBarContainerView.trailingAnchor constraintEqualToAnchor:tokenBalancesLabel.trailingAnchor constant:kHomeStretchyHeaderDefaultOffset].active = YES;
      self.tokenBalancesTopConstraints = [tokenBalancesLabel.topAnchor constraintEqualToAnchor:searchBarContainerView.topAnchor constant:kHomeStretchyHeaderTokensTitleTopMaxOffset];
      [searchBarContainerView addConstraint:self.tokenBalancesTopConstraints];
      self.tokenBalancesLabel = tokenBalancesLabel;
    }
    {
      UISearchBar *searchBar = [[MEWSearchBar alloc] init];
      searchBar.searchBarStyle = UISearchBarStyleMinimal;
      searchBar.translatesAutoresizingMaskIntoConstraints = NO;
      [searchBarContainerView addSubview:searchBar];
      CGFloat hOffset = kHomeStretchyHeaderSearchBarHOffset;
      if ([UIScreen mainScreen].screenSizeType == ScreenSizeTypeInches40) {
        hOffset = kHomeStretchyHeaderSearchBarHOffset40Inches;
      }
      NSDictionary *metrics = @{@"LOFFSET": @(hOffset),
                                @"ROFFSET": @(hOffset)};
      NSDictionary *views = @{@"search": searchBar};
      [searchBarContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(LOFFSET)-[search]-(ROFFSET)-|" options:0 metrics:metrics views:views]];
      self.searchBarBottomConstraint = [searchBarContainerView.bottomAnchor constraintEqualToAnchor:searchBar.bottomAnchor constant:kHomeStretchyHeaderSearchBarBMaxOffset];
      [searchBarContainerView addConstraint:self.searchBarBottomConstraint];
      _searchBar = searchBar;
      _searchBar.placeholder = @"Search 81 tokens";
    }
  }
}

- (void) _updateStatusBarStyleWithScrollFactor:(CGFloat)scrollFactor {
  if (scrollFactor < 1.0) {
    if (self.statusBarStyle != UIStatusBarStyleDefault) {
      self.statusBarStyle = UIStatusBarStyleDefault;
      [self.delegate homeStretchyHeaderRequirinUpdateStatusBarStyle:self];
    }
  } else {
    if (self.statusBarStyle != UIStatusBarStyleLightContent) {
      self.statusBarStyle = UIStatusBarStyleLightContent;
      [self.delegate homeStretchyHeaderRequirinUpdateStatusBarStyle:self];
    }
  }
}

- (void) _updateContentStyleWithScrollFactor:(CGFloat)scrollFactor {
  if (scrollFactor > 0.4) {
    if (self.contentStyle != HomeStretchyHeaderStyleLightContent) {
      self.contentStyle = HomeStretchyHeaderStyleLightContent;
      NSMutableAttributedString *buyEtherAttributedString = [[self.buyEtherButton attributedTitleForState:UIControlStateNormal] mutableCopy];
      [buyEtherAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor mainApplicationColor] range:NSMakeRange(0, [buyEtherAttributedString length])];
      [UIView transitionWithView:self.titleLabel
                        duration:kHomeStretchyHeaderFadeDuration
                         options:UIViewAnimationOptionTransitionCrossDissolve|UIViewAnimationOptionBeginFromCurrentState
                      animations:^{
                        self.titleLabel.textColor = [UIColor whiteColor];
                        self.infoButton.tintColor = [UIColor whiteColor];
                        self.buyEtherButton.tintColor = [UIColor whiteColor];
                        [self.buyEtherButton setAttributedTitle:buyEtherAttributedString forState:UIControlStateNormal];
                      } completion:nil];
#if BETA
      [UIView transitionWithView:self.betaIconImageView
                        duration:kHomeStretchyHeaderFadeDuration
                         options:UIViewAnimationOptionTransitionCrossDissolve|UIViewAnimationOptionBeginFromCurrentState
                      animations:^{
                        [self.betaIconImageView setImage:[UIImage imageNamed:@"beta_icon_white"]];
                      } completion:nil];
#endif
    }
  } else {
    if (self.contentStyle != HomeStretchyHeaderStyleDefault) {
      self.contentStyle = HomeStretchyHeaderStyleDefault;
      NSMutableAttributedString *buyEtherAttributedString = [[self.buyEtherButton attributedTitleForState:UIControlStateNormal] mutableCopy];
      [buyEtherAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor mainApplicationColor] range:NSMakeRange(0, [buyEtherAttributedString length])];
      [UIView transitionWithView:self.titleLabel
                        duration:kHomeStretchyHeaderFadeDuration
                         options:UIViewAnimationOptionTransitionCrossDissolve|UIViewAnimationOptionBeginFromCurrentState
                      animations:^{
                        self.titleLabel.textColor = [UIColor darkTextColor];
                        self.infoButton.tintColor = [[UIColor mainApplicationColor] colorWithAlphaComponent:0.1];
                        self.buyEtherButton.tintColor = [[UIColor mainApplicationColor] colorWithAlphaComponent:0.1];
                        [self.buyEtherButton setAttributedTitle:buyEtherAttributedString forState:UIControlStateNormal];
                      } completion:nil];
#if BETA
      [UIView transitionWithView:self.betaIconImageView
                        duration:kHomeStretchyHeaderFadeDuration
                         options:UIViewAnimationOptionTransitionCrossDissolve|UIViewAnimationOptionBeginFromCurrentState
                      animations:^{
                        [self.betaIconImageView setImage:[UIImage imageNamed:@"beta_icon"]];
                      } completion:nil];
#endif
    }
  }
}

#pragma mark - Override

- (void) didMoveToSuperview {
  [super didMoveToSuperview];
  if (self.superview) {
    self.titleLabelTopConstraint.active = YES;
    [self.infoButton.topAnchor constraintEqualToAnchor:self.delegate.topLayoutGuide.bottomAnchor constant:10.0].active = YES;
    [self.buyEtherButton.topAnchor constraintEqualToAnchor:self.delegate.topLayoutGuide.bottomAnchor constant:10.0].active = YES;
  }
}

- (void) didChangeStretchFactor:(CGFloat)stretchFactor {
  stretchFactor = MAX(0.0, MIN(1.0, 1.0 - stretchFactor));
  CGFloat searchBarContainerDif = kHomeStretchyHeaderMaxSearchBarHeight - kHomeStretchyHeaderMinSearchBarHeight;
  CGFloat searchBarContainerStretchFactor = MAX(0.0, MIN(1.0, (CGRectGetHeight(self.bounds) - self.minimumContentHeight) / searchBarContainerDif));
  
  CGFloat titleBarOffsetDif = kHomeStretchyHeaderTitleTopMaxOffset - kHomeStretchyHeaderTitleTopMinOffset;
  CGFloat titleStretchFactor = MAX(0.0, MIN(1.0, (CGRectGetHeight(self.bounds) - self.minimumContentHeight - searchBarContainerDif) / titleBarOffsetDif));
  
  CGVector scrollRange = CGVectorMake(0.0, 0.4);
  CGVector alphaRange = CGVectorMake(0.2, 0.45);
  CGVector lrRange = CGVectorMake(0.3, 0.55);
  CGVector shadowRange = CGVectorMake(0.0, 0.3);
  CGVector cornerRadiusRange = CGVectorMake(0.5, 0.7);
  CGVector titleBarContentRange = CGVectorMake(0.8, 0.91);
  
  CGVector searchBarBackgroundRange = CGVectorMake(0.0, 0.25);
  
  CGFloat scrollFactor = MAX(scrollRange.dx, MIN(scrollRange.dy, stretchFactor)) * (1.0 / (scrollRange.dy - scrollRange.dx));
  CGFloat alphaFactor = 1.0 - (MAX(alphaRange.dx, MIN(alphaRange.dy, stretchFactor)) - alphaRange.dx) * (1.0 / (alphaRange.dy - alphaRange.dx));
  CGFloat lrFactor = (MAX(lrRange.dx, MIN(lrRange.dy, stretchFactor)) - lrRange.dx) * (1.0 / (lrRange.dy - lrRange.dx));
  CGFloat shadowFactor = (MAX(shadowRange.dx, MIN(shadowRange.dy, stretchFactor)) - shadowRange.dx) * (1.0 / (shadowRange.dy - shadowRange.dx));
  CGFloat cornerRadiusFactor = (MAX(cornerRadiusRange.dx, MIN(cornerRadiusRange.dy, stretchFactor)) - cornerRadiusRange.dx) * (1.0 / (cornerRadiusRange.dy - cornerRadiusRange.dx));
  CGFloat titleBarContentStretchFactor = 1.0 - (MAX(titleBarContentRange.dx, MIN(titleBarContentRange.dy, stretchFactor)) - titleBarContentRange.dx) * (1.0 / (titleBarContentRange.dy - titleBarContentRange.dx));
  
  CGFloat searchBarBackgroundAlphaFactor = (MAX(searchBarBackgroundRange.dx, MIN(searchBarBackgroundRange.dy, stretchFactor)) - searchBarBackgroundRange.dx) * (1.0 / (searchBarBackgroundRange.dy - searchBarBackgroundRange.dx));
  
  [self _updateStatusBarStyleWithScrollFactor:scrollFactor];
  [self _updateContentStyleWithScrollFactor:scrollFactor];
  
  self.cardTopConstraint.constant = CGFloatInterpolate(scrollFactor, kHomeStretchyHeaderTopDefaultOffset + _safeHeight, 0.0);
  self.cardRightConstraint.constant = self.cardLeftConstraint.constant = CGFloatInterpolate(lrFactor, kHomeStretchyHeaderDefaultOffset, 0.0);
  self.cardView.alpha = alphaFactor;
  self.cardView.layer.shadowOpacity = CGFloatInterpolate(shadowFactor, kCardViewDefaultShadowOpacity, 0.0);
  self.patternImageView.layer.cornerRadius = CGFloatInterpolate(cornerRadiusFactor, kCardViewDefaultCornerRadius, 0.0);
  
  self.searchBarContainerHeightConstraints.constant = CGFloatInterpolate(searchBarContainerStretchFactor, kHomeStretchyHeaderMinSearchBarHeight, kHomeStretchyHeaderMaxSearchBarHeight);
  CGFloat fontSize = CGFloatInterpolate(searchBarContainerStretchFactor, kHomeStretchyHeaderTokensTitleMinFontSize, kHomeStretchyHeaderTokensTitleMaxFontSize);
  self.tokenBalancesTitleLabel.font = [UIFont systemFontOfSize:fontSize weight:UIFontWeightBold];
  self.tokenBalancesLabel.font = [UIFont systemFontOfSize:fontSize weight:UIFontWeightRegular];
  self.searchBarBackgroundImageView.alpha = searchBarBackgroundAlphaFactor;
  self.tokenBalancesTitleTopConstraints.constant = self.tokenBalancesTopConstraints.constant = CGFloatInterpolate(searchBarContainerStretchFactor, kHomeStretchyHeaderTokensTitleTopMinOffset, _tokensTitleTopMaxOffset);
  self.searchBarBottomConstraint.constant = CGFloatInterpolate(searchBarContainerStretchFactor, kHomeStretchyHeaderSearchBarBMinOffset, kHomeStretchyHeaderSearchBarBMaxOffset);
  
  self.titleLabelTopConstraint.constant = CGFloatInterpolate(titleStretchFactor, kHomeStretchyHeaderTitleTopMinOffset, kHomeStretchyHeaderTitleTopMaxOffset);
  
  self.titleBalanceLabel.alpha = 1.0 - titleBarContentStretchFactor;
  CGFloat networkScale = CGFloatInterpolate(titleBarContentStretchFactor, kHomeStretchyHeaderNetworkButtonMinScale, kHomeStretchyHeaderNetworkButtonMaxScale);
  self.networkButtonTopConstraint.constant = CGFloatInterpolate(titleBarContentStretchFactor, kHomeStretchyHeaderTitleTopMaxOffset - kHomeStretchyHeaderTitleTopMinOffset, /*kHomeStretchyHeaderTitleTopMaxOffset - kHomeStretchyHeaderTitleTopMaxOffset*/ 0.0);
  self.titleBalanceLabelTopConstraint.constant = CGFloatInterpolate(titleBarContentStretchFactor, kHomeStretcyHeaderTitleBalanceTopMinOffset, kHomeStretcyHeaderTitleBalanceTopMaxOffset);
  self.networkButton.transform = CGAffineTransformMakeScale(networkScale, networkScale);
  self.networkButton.alpha = titleBarContentStretchFactor;
  
  
  [self.delegate homeStretchyHeaderViewDidChangeBackgroundAlpha:searchBarBackgroundAlphaFactor];
}
   
@end
