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

#import "UIImage+Color.h"
#import "UIColor+Hex.h"
#import "UIColor+Application.h"

#import "NSNumberFormatter+USD.h"

typedef NS_ENUM(NSInteger, HomeStretchyHeaderStyle) {
  HomeStretchyHeaderStyleDefault,
  HomeStretchyHeaderStyleLightContent,
};

static CGFloat const kHomeStretchyHeaderMinimumContentHeight      = 130.0;
static CGFloat const kHomeStretchyHeaderMaximumContentHeight      = 176.0;

NSTimeInterval const kHomeStretchyHeaderFadeDuration              = 0.2;

static CGFloat const kHomeStretchyHeaderDefaultOffset             = 16.0;
static CGFloat const kHomeStretchyHeaderTopDefaultOffset          = 48.0;

static CGFloat const kHomeStretchyHeaderTitleTopMinOffset         = 6.0;
static CGFloat const kHomeStretchyHeaderTitleTopMaxOffset         = 14.0;

static CGFloat const kHomeStretchyHeaderMinSearchBarHeight        = 82.0;
static CGFloat const kHomeStretchyHeaderMaxSearchBarHeight        = 104.0;

static CGFloat const kHomeStretchyHeaderTokensTitleMinFontSize    = 17.0;
static CGFloat const kHomeStretchyHeaderTokensTitleMaxFontSize    = 22.0;

static CGFloat const kHomeStretchyHeaderTokensTitleTopMinOffset   = 14.0;
static CGFloat const kHomeStretchyHeaderTokensTitleTopMaxOffset   = 17.0;

static CGFloat const kHomeStretchyHeaderSearchBarHOffset          = 8.0;
static CGFloat const kHomeStretchyHeaderSearchBarBMinOffset       = 0.0;
static CGFloat const kHomeStretchyHeaderSearchBarBMaxOffset       = 8.0;

@interface HomeStretchyHeader ()
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, strong) NSLayoutConstraint *titleLabelTopConstraint;

@property (nonatomic, weak) UIImageView *patternImageView;
@property (nonatomic, strong) NSLayoutConstraint *cardLeftConstraint;
@property (nonatomic, strong) NSLayoutConstraint *cardRightConstraint;
@property (nonatomic, strong) NSLayoutConstraint *cardTopConstraint;

@property (nonatomic, strong) NSLayoutConstraint *searchBarContainerHeightConstraints;
@property (nonatomic, strong) NSLayoutConstraint *tokenBalancesTitleTopConstraints;
@property (nonatomic, strong) NSLayoutConstraint *tokenBalancesTopConstraints;
@property (nonatomic, strong) NSLayoutConstraint *searchBarBottomConstraint;
@property (nonatomic, weak) UIImageView *searchBarBackgroundImageView;
@property (nonatomic, weak) UILabel *tokenBalancesTitleLabel;
@property (nonatomic, weak) UILabel *tokenBalancesLabel;

@property (nonatomic) HomeStretchyHeaderStyle contentStyle;
@property (nonatomic) UIStatusBarStyle statusBarStyle;
@end

@implementation HomeStretchyHeader {
  CGFloat _safeHeight;
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

- (void)refreshContentIfNeeded {
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
    CGFloat newHeight = kHomeStretchyHeaderMaximumContentHeight + self.cardView.intrinsicContentSize.height + _safeHeight;
    [self setMaximumContentHeight:newHeight resetAnimated:NO];
    if (self.cardTopConstraint.constant == kHomeStretchyHeaderTopDefaultOffset + oldSafeHeight) {
      self.cardTopConstraint.constant = kHomeStretchyHeaderTopDefaultOffset + _safeHeight;
    }
  }
}

- (void)setSearchBarStyle:(HomeStretchyHeaderSearchBarStyle)searchBarStyle {
  if (_searchBarStyle != searchBarStyle) {
    _searchBarStyle = searchBarStyle;
    UIColor *color = [UIColor whiteColor];
    switch (searchBarStyle) {
      case HomeStretchyHeaderSearchBarStyleLightBlue: {
        color = [UIColor applicationLightBlue];
        break;
      }
      case HomeStretchyHeaderSearchBarStyleWhite: {
        color = [UIColor whiteColor];
        break;
      }
      default:
        break;
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
    [titleLabel.centerXAnchor constraintEqualToAnchor:self.contentView.centerXAnchor].active = YES;
    self.titleLabelTopConstraint = [titleLabel.topAnchor constraintEqualToAnchor:self.delegate.topLayoutGuide.bottomAnchor constant:kHomeStretchyHeaderTitleTopMaxOffset];
    self.titleLabel = titleLabel;
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
    [titleBalanceLabel.topAnchor constraintEqualToAnchor:titleLabel.bottomAnchor constant:0.0].active = YES;
    _titleBalanceLabel = titleBalanceLabel;
  }
  UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeSystem];
  {
    infoButton.translatesAutoresizingMaskIntoConstraints = NO;
    [infoButton setImage:[UIImage imageNamed:@"i_icon"] forState:UIControlStateNormal];
    infoButton.tintColor = [UIColor mainApplicationColor];
    [infoButton setContentEdgeInsets:UIEdgeInsetsMake(4.0, 4.0, 4.0, 4.0)];
    [self.contentView addSubview:infoButton];
    [infoButton.leftAnchor constraintEqualToAnchor:self.contentView.leftAnchor constant:kHomeStretchyHeaderDefaultOffset].active = YES;
    _infoButton = infoButton;
  }
  UIButton *buyEtherButton = [UIButton buttonWithType:UIButtonTypeSystem];
  {
    buyEtherButton.translatesAutoresizingMaskIntoConstraints = NO;
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
      self.tokenBalancesTitleTopConstraints = [NSLayoutConstraint constraintWithItem:tokenBalancesTitle attribute:NSLayoutAttributeTop
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:searchBarContainerView attribute:NSLayoutAttributeTop
                                                                          multiplier:1.0 constant:kHomeStretchyHeaderTokensTitleTopMaxOffset];
      [searchBarContainerView addConstraint:self.tokenBalancesTitleTopConstraints];
      self.tokenBalancesTitleLabel = tokenBalancesTitle;
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
      NSDictionary *metrics = @{@"LOFFSET": @(kHomeStretchyHeaderSearchBarHOffset),
                                @"ROFFSET": @(kHomeStretchyHeaderSearchBarHOffset)};
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
                        self.infoButton.tintColor = [UIColor mainApplicationColor];
                        self.buyEtherButton.tintColor = [[UIColor mainApplicationColor] colorWithAlphaComponent:0.1];
                        [self.buyEtherButton setAttributedTitle:buyEtherAttributedString forState:UIControlStateNormal];
                      } completion:nil];
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
  CGVector blinkAlphaRange = CGVectorMake(0.0, 0.3);
  CGVector shadowRange = CGVectorMake(0.0, 0.3);
  CGVector cornerRadiusRange = CGVectorMake(0.5, 0.7);
  
  CGVector searchBarBackgroundRange = CGVectorMake(0.0, 0.25);
  
  CGFloat scrollFactor = MAX(scrollRange.dx, MIN(scrollRange.dy, stretchFactor)) * (1.0 / (scrollRange.dy - scrollRange.dx));
  CGFloat alphaFactor = 1.0 - (MAX(alphaRange.dx, MIN(alphaRange.dy, stretchFactor)) - alphaRange.dx) * (1.0 / (alphaRange.dy - alphaRange.dx));
  CGFloat lrFactor = (MAX(lrRange.dx, MIN(lrRange.dy, stretchFactor)) - lrRange.dx) * (1.0 / (lrRange.dy - lrRange.dx));
  CGFloat blinkFactor = (MAX(blinkAlphaRange.dx, MIN(blinkAlphaRange.dy, stretchFactor)) - blinkAlphaRange.dx) * (1.0 / (blinkAlphaRange.dy - blinkAlphaRange.dx));
  CGFloat shadowFactor = (MAX(shadowRange.dx, MIN(shadowRange.dy, stretchFactor)) - shadowRange.dx) * (1.0 / (shadowRange.dy - shadowRange.dx));
  CGFloat cornerRadiusFactor = (MAX(cornerRadiusRange.dx, MIN(cornerRadiusRange.dy, stretchFactor)) - cornerRadiusRange.dx) * (1.0 / (cornerRadiusRange.dy - cornerRadiusRange.dx));
  
  CGFloat searchBarBackgroundAlphaFactor = (MAX(searchBarBackgroundRange.dx, MIN(searchBarBackgroundRange.dy, stretchFactor)) - searchBarBackgroundRange.dx) * (1.0 / (searchBarBackgroundRange.dy - searchBarBackgroundRange.dx));
  
  [self _updateStatusBarStyleWithScrollFactor:scrollFactor];
  [self _updateContentStyleWithScrollFactor:scrollFactor];
  
  self.cardTopConstraint.constant = CGFloatInterpolate(scrollFactor, kHomeStretchyHeaderTopDefaultOffset + _safeHeight, 0.0);
  self.cardRightConstraint.constant = self.cardLeftConstraint.constant = CGFloatInterpolate(lrFactor, kHomeStretchyHeaderDefaultOffset, 0.0);
  self.cardView.alpha = alphaFactor;
  self.cardView.blinkImageView.alpha = CGFloatInterpolate(blinkFactor, kCardViewBlinkDefaultAlpha, 0.0);
  self.cardView.layer.shadowOpacity = CGFloatInterpolate(shadowFactor, kCardViewDefaultShadowOpacity, 0.0);
  self.patternImageView.layer.cornerRadius = CGFloatInterpolate(cornerRadiusFactor, kCardViewDefaultCornerRadius, 0.0);
  
  self.searchBarContainerHeightConstraints.constant = CGFloatInterpolate(searchBarContainerStretchFactor, kHomeStretchyHeaderMinSearchBarHeight, kHomeStretchyHeaderMaxSearchBarHeight);
  CGFloat fontSize = CGFloatInterpolate(searchBarContainerStretchFactor, kHomeStretchyHeaderTokensTitleMinFontSize, kHomeStretchyHeaderTokensTitleMaxFontSize);
  self.tokenBalancesTitleLabel.font = [UIFont systemFontOfSize:fontSize weight:UIFontWeightBold];
  self.tokenBalancesLabel.font = [UIFont systemFontOfSize:fontSize weight:UIFontWeightRegular];
  self.searchBarBackgroundImageView.alpha = searchBarBackgroundAlphaFactor;
  self.tokenBalancesTitleTopConstraints.constant = self.tokenBalancesTopConstraints.constant = CGFloatInterpolate(searchBarContainerStretchFactor, kHomeStretchyHeaderTokensTitleTopMinOffset, kHomeStretchyHeaderTokensTitleTopMaxOffset);
  self.searchBarBottomConstraint.constant = CGFloatInterpolate(searchBarContainerStretchFactor, kHomeStretchyHeaderSearchBarBMinOffset, kHomeStretchyHeaderSearchBarBMaxOffset);
  
  self.titleLabelTopConstraint.constant = CGFloatInterpolate(titleStretchFactor, kHomeStretchyHeaderTitleTopMinOffset, kHomeStretchyHeaderTitleTopMaxOffset);
  self.titleBalanceLabel.alpha = 1.0 - titleStretchFactor;
  [self.delegate homeStretchyHeaderViewDidChangeBackgroundAlpha:searchBarBackgroundAlphaFactor];
}
   
@end
