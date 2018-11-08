//
//  CardView.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 09/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import TTTAttributedLabel;

#import "CardView.h"
#import "CardViewSeedButton.h"
#import "UIImage+MEWBackground.h"
#import "NSAttributedString+CustomEllipsis.h"
#import "NSNumberFormatter+Ethereum.h"
#import "NSNumberFormatter+USD.h"
#import "UIColor+Application.h"
#import "UIColor+Hex.h"
#import "UIImage+Color.h"
#import "InlineButton.h"

#import "UIScreen+ScreenSizeType.h"

static CGFloat kCardViewSmallOffset             = 6.0;
static CGFloat kCardViewEthereumTitleTopOffset  = 87.0;

CGFloat const kCardViewDefaultShadowOpacity     = 0.2;
CGFloat const kCardViewDefaultCornerRadius      = 16.0;
CGFloat const kCardViewDefaultOffset            = 16.0;
CGFloat const kCardViewAspectRatio              = 216.0/343.0;;

@interface CardView() <CALayerDelegate>
@property (nonatomic, weak) UIButton *backupStatusButton;
@property (nonatomic, weak) UIImageView *backgroundImageView;
@property (nonatomic, weak) UILabel *balanceLabel;
@property (nonatomic, weak) UILabel *usdBalanceLabel;
@property (nonatomic, weak) UILabel *ethereumTitleLabel;
@property (nonatomic, weak) UIButton *seedLabelButton;
@property (nonatomic, weak) UIView *backupViewWarning;
@property (nonatomic, weak) UIView *backupViewOk;
@end

@implementation CardView {
  NSString *_seed;
  NSDecimalNumber *_ethBalance;
  BlockchainNetworkType _network;
  NSDecimalNumber *_ethToUsdPrice;
}

- (instancetype) initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    [self _commonInit];
  }
  return self;
}

- (void)awakeFromNib {
  [super awakeFromNib];
  [self _commonInit];
}

- (CGSize)intrinsicContentSize {
  return [UIImage cardSize];
}

#pragma mark - Public

- (void) updateWithSeed:(NSString *)seed {
  if (!seed) {
    seed = @"";
  }
  if ([_seed isEqualToString:seed]) {
    return;
  }
  _seed = seed;
  
  CGSize fullSize = [UIImage fullSize];
  CGSize cardSize = [UIImage cardSize];

  UIImage *patternImage = nil;
  _backgroundImage = [UIImage cachedBackgroundWithSeed:seed size:fullSize logo:NO];
  if (!_backgroundImage) {
    patternImage = [UIImage imageWithSeed:seed size:fullSize];
    _backgroundImage = [patternImage renderBackgroundWithSeed:seed size:fullSize logo:NO];
  }
  UIImage *cardImage = [UIImage cachedBackgroundWithSeed:seed size:cardSize logo:YES];
  if (self.backgroundImageView.image && cardImage) {
    [UIView transitionWithView:self.backgroundImageView
                      duration:0.3
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                      self.backgroundImageView.image = cardImage;
                    } completion:nil];
  } else {
    self.backgroundImageView.image = cardImage;
  }
  if (!self.backgroundImageView.image) {
    if (!patternImage) {
      patternImage = [UIImage imageWithSeed:seed size:fullSize];
    }
    self.backgroundImageView.image = [patternImage renderBackgroundWithSeed:seed size:cardSize logo:YES];
  }
  
  NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
  style.lineBreakMode = NSLineBreakByTruncatingMiddle;
  style.baseWritingDirection = NSWritingDirectionLeftToRight;
  UIFont *font = nil;
  UIFont *ellipsesFont = nil;
  if ([UIScreen mainScreen].screenSizeType == ScreenSizeTypeInches40) {
    font = [UIFont systemFontOfSize:19.0 weight:UIFontWeightMedium];
    ellipsesFont = [UIFont fontWithName:@"PingFangSC-Medium" size:19.0];
  } else {
    font = [UIFont systemFontOfSize:22.0 weight:UIFontWeightMedium];
    ellipsesFont = [UIFont fontWithName:@"PingFangSC-Medium" size:22.0];
  }
  NSDictionary *attributes = @{NSForegroundColorAttributeName: [UIColor whiteColor],
                               NSFontAttributeName: font,
                               NSParagraphStyleAttributeName: style};
  
  NSDictionary *ellipsesAttributes = @{NSFontAttributeName: ellipsesFont,
                                       NSForegroundColorAttributeName: [UIColor whiteColor],
                                       NSKernAttributeName: @(0.35)};
  NSAttributedString *ellipsis = [[NSAttributedString alloc] initWithString:@"⋯" attributes:ellipsesAttributes];
  
  NSAttributedString *attributedSeedString = [[NSAttributedString alloc] initWithString:seed attributes:attributes];
  CGSize maxSize = CGSizeMake(0.0, CGFLOAT_MAX);
  UIImage *shareIcon = [self.seedLabelButton imageForState:UIControlStateNormal];
  maxSize.width = [self intrinsicContentSize].width;
  maxSize.width -= kCardViewDefaultOffset; //left offset
  maxSize.width -= shareIcon.size.width + 16.0; //share icon
  maxSize.width -= kCardViewDefaultOffset;//right offset
  if ([attributedSeedString length] > 6) {
    attributedSeedString = [attributedSeedString truncatedAttributedStringWithCustomEllipsis:ellipsis maxSize:maxSize truncationPosition:6];
  }
  
  [self.seedLabelButton setAttributedTitle:attributedSeedString forState:UIControlStateNormal];
}

/* 0.5679 ETH */
- (void) updateBalance:(NSDecimalNumber *)balance network:(BlockchainNetworkType)network {
  _ethBalance = balance;
  _network = network;
  if (!balance) {
    balance = [NSDecimalNumber zero];
  }
  
  NSNumberFormatter *ethereumFormatter = [NSNumberFormatter ethereumFormatterWithNetwork:network];
  ethereumFormatter.maximumSignificantDigits = 8;
  switch (network) {
    case BlockchainNetworkTypeMainnet: {
      switch ([UIScreen mainScreen].screenSizeType) {
        case ScreenSizeTypeInches40: {
          ethereumFormatter.maximumSignificantDigits = 9;
          break;
        }
        case ScreenSizeTypeInches47:
        case ScreenSizeTypeInches58: {
          ethereumFormatter.maximumSignificantDigits = 10;
          break;
        }
        case ScreenSizeTypeInches55: {
          ethereumFormatter.maximumSignificantDigits = 12;
          break;
        }
        default:
          ethereumFormatter.maximumSignificantDigits = 8;
          break;
      }
      break;
    }
    case BlockchainNetworkTypeRopsten: {
      switch ([UIScreen mainScreen].screenSizeType) {
        case ScreenSizeTypeInches40: {
          ethereumFormatter.maximumSignificantDigits = 5;
          break;
        }
        case ScreenSizeTypeInches47:
        case ScreenSizeTypeInches58: {
          ethereumFormatter.maximumSignificantDigits = 5;
          break;
        }
        case ScreenSizeTypeInches55: {
          ethereumFormatter.maximumSignificantDigits = 7;
          break;
        }
        default:
          ethereumFormatter.maximumSignificantDigits = 8;
          break;
      }
      break;
    }
      
    default:
      break;
  }
  
  UIFont *balanceFont = nil;
  UIFont *currencyFont = nil;
  if ([UIScreen mainScreen].screenSizeType == ScreenSizeTypeInches40) {
    balanceFont = [UIFont systemFontOfSize:26.0 weight:UIFontWeightSemibold];
    currencyFont = [UIFont systemFontOfSize:16.0 weight:UIFontWeightBold];
  } else {
    balanceFont = [UIFont systemFontOfSize:30.0 weight:UIFontWeightSemibold];
    currencyFont = [UIFont systemFontOfSize:20.0 weight:UIFontWeightBold];
  }
  
  NSString *balanceText = [ethereumFormatter stringFromNumber:balance];
  NSDictionary *balanceAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor],
                                      NSFontAttributeName: balanceFont,
                                      NSKernAttributeName: @0.5};
  NSDictionary *currencyAttributes = @{NSFontAttributeName: currencyFont};
  NSMutableAttributedString *balanceAttributedText = [[NSMutableAttributedString alloc] initWithString:balanceText attributes:balanceAttributes];
  NSRange currencyRange = [balanceText rangeOfString:ethereumFormatter.currencySymbol];
  if (currencyRange.location != NSNotFound) {
    [balanceAttributedText addAttributes:currencyAttributes range:currencyRange];
  }
  self.balanceLabel.attributedText = balanceAttributedText;
  [self _updateUsdBalance];
}

- (void) updateEthPrice:(NSDecimalNumber *)price {
  _ethToUsdPrice = price;
  [self _updateUsdBalance];
}

- (void)setBackedUp:(BOOL)backedUp {
  if (_backedUp != backedUp) {
    _backedUp = backedUp;
    [self.backupViewWarning removeFromSuperview];
    [self.backupViewOk removeFromSuperview];
    if (_backedUp) {
      UIView *backupOkView = [self _prepareBackupOkView];
      [self addSubview:backupOkView];
      NSDictionary *metrics = @{@"LOFFSET": @(kCardViewDefaultOffset / 2.0),
                                @"BOFFSET": @(kCardViewDefaultOffset + 1.0)};
      NSDictionary *views = @{@"backup": backupOkView};
      [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(LOFFSET)-[backup]" options:NSLayoutFormatDirectionLeftToRight metrics:metrics views:views]];
      [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[backup]-(BOFFSET)-|" options:NSLayoutFormatDirectionLeftToRight metrics:metrics views:views]];
      self.backupViewOk = backupOkView;
      
    } else {
      
      UIView *backupWarningView = [self _prepareBackupWarningView];
      [self addSubview:backupWarningView];
      NSDictionary *metrics = @{@"LOFFSET": @(kCardViewDefaultOffset / 2.0),
                                @"ROFFSET": @(kCardViewDefaultOffset / 2.0),
                                @"BOFFSET": @(kCardViewDefaultOffset / 2.0)};
      NSDictionary *views = @{@"backup": backupWarningView};
      [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(LOFFSET)-[backup]-(ROFFSET)-|" options:NSLayoutFormatDirectionLeftToRight metrics:metrics views:views]];
      [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[backup]-(BOFFSET)-|" options:NSLayoutFormatDirectionLeftToRight metrics:metrics views:views]];
      self.backupViewWarning = backupWarningView;
    }
  }
}

#pragma mark - Private

- (void) _commonInit {
  { //Background
    UIImageView *backgroundImageView = [[UIImageView alloc] init];
    backgroundImageView.layer.masksToBounds = YES;
    backgroundImageView.layer.cornerRadius = kCardViewDefaultCornerRadius;
    backgroundImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:backgroundImageView];
    NSDictionary *views = @{@"background": backgroundImageView};
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[background]|" options:NSLayoutFormatDirectionLeftToRight metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[background]|" options:NSLayoutFormatDirectionLeftToRight metrics:nil views:views]];
    self.backgroundImageView = backgroundImageView;
  }
  { //Balance
    UILabel *balanceLabel = [[UILabel alloc] init];
    balanceLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:balanceLabel];
    CGFloat correction = 1.0;
    if ([UIScreen mainScreen].screenSizeType == ScreenSizeTypeInches40) {
      correction = 0.0;
    }
    [self addConstraint:[NSLayoutConstraint constraintWithItem:balanceLabel attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self attribute:NSLayoutAttributeTop
                                                    multiplier:1.0 constant:kCardViewDefaultOffset + correction]];
    NSDictionary *views = @{@"balance": balanceLabel};
    UIImage *logo = nil;
    if ([UIScreen mainScreen].screenSizeType == ScreenSizeTypeInches40) {
      logo = [UIImage imageNamed:@"ethereum_logo_small"];
    } else {
      logo = [UIImage imageNamed:@"ethereum_logo"];
    }
    
    NSDictionary *metrics = @{@"LOFFSET": @(kCardViewDefaultOffset),
                              @"ROFFSET": @(kCardViewDefaultOffset * 2.0 + logo.size.width)};
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(LOFFSET)-[balance]-(ROFFSET)-|" options:NSLayoutFormatDirectionLeftToRight metrics:metrics views:views]];
    self.balanceLabel = balanceLabel;
  }
  { //USD balance
    UILabel *usdBalanceLabel = [[UILabel alloc] init];
    usdBalanceLabel.translatesAutoresizingMaskIntoConstraints = NO;
    usdBalanceLabel.alpha = 0.5;
    usdBalanceLabel.hidden = YES;
    [self addSubview:usdBalanceLabel];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:usdBalanceLabel attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.balanceLabel attribute:NSLayoutAttributeLeft
                                                    multiplier:1.0 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:usdBalanceLabel attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.balanceLabel attribute:NSLayoutAttributeRight
                                                    multiplier:1.0 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:usdBalanceLabel attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.balanceLabel attribute:NSLayoutAttributeBottom
                                                    multiplier:1.0 constant:-1.0]];
    self.usdBalanceLabel = usdBalanceLabel;
  }
  { //Your public Ethereum address
    UILabel *ethereumTitleLabel = [[UILabel alloc] init];
    ethereumTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    ethereumTitleLabel.alpha = 0.5;
    [self addSubview:ethereumTitleLabel];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:ethereumTitleLabel attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.balanceLabel attribute:NSLayoutAttributeLeft
                                                    multiplier:1.0 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                        toItem:self.balanceLabel attribute:NSLayoutAttributeRight
                                                    multiplier:1.0 constant:kCardViewDefaultOffset]];
    CGFloat offset = kCardViewEthereumTitleTopOffset;
    UIFont *font = nil;
    if ([UIScreen mainScreen].screenSizeType == ScreenSizeTypeInches40) {
      offset = 62.0;
      font = [UIFont systemFontOfSize:10.0 weight:UIFontWeightRegular];
    } else {
      font = [UIFont systemFontOfSize:12.0 weight:UIFontWeightRegular];
    }
    [self addConstraint:[NSLayoutConstraint constraintWithItem:ethereumTitleLabel attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self attribute:NSLayoutAttributeTop
                                                    multiplier:1.0 constant:offset]];
    NSDictionary *attributes = @{NSForegroundColorAttributeName: [UIColor whiteColor],
                                 NSFontAttributeName: font,
                                 NSKernAttributeName: @0.0};
    NSString *title = NSLocalizedString(@"Your public Ethereum address", @"Card view");
    ethereumTitleLabel.attributedText = [[NSAttributedString alloc] initWithString:title attributes:attributes];
    self.ethereumTitleLabel = ethereumTitleLabel;
  }
  { //Seed label + Share
    UIButton *seedLabelButton = [CardViewSeedButton seedButton];
    [seedLabelButton addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    seedLabelButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:seedLabelButton];
    CGFloat verticalOffset = 0.0;
    if ([UIScreen mainScreen].screenSizeType == ScreenSizeTypeInches40) {
      verticalOffset = 2.0;
    } else {
      verticalOffset = -1.0;
    }
    [seedLabelButton.leftAnchor constraintEqualToAnchor:self.balanceLabel.leftAnchor].active = YES;
    [seedLabelButton.topAnchor constraintEqualToAnchor:self.ethereumTitleLabel.bottomAnchor constant:verticalOffset].active = YES;
    [seedLabelButton.superview.rightAnchor constraintEqualToAnchor:seedLabelButton.rightAnchor constant:kCardViewDefaultOffset].active = YES;
    self.seedLabelButton = seedLabelButton;
  }
  { //Warning view
    UIView *backupWarningView = [self _prepareBackupWarningView];
    [self addSubview:backupWarningView];
    NSDictionary *metrics = @{@"LOFFSET": @(kCardViewDefaultOffset / 2.0),
                              @"ROFFSET": @(kCardViewDefaultOffset / 2.0),
                              @"BOFFSET": @(kCardViewDefaultOffset / 2.0)};
    NSDictionary *views = @{@"backup": backupWarningView};
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(LOFFSET)-[backup]-(ROFFSET)-|" options:NSLayoutFormatDirectionLeftToRight metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[backup]-(BOFFSET)-|" options:NSLayoutFormatDirectionLeftToRight metrics:metrics views:views]];
    self.backupViewWarning = backupWarningView;
  }
  
  { //Shadow
    self.layer.cornerRadius = kCardViewDefaultCornerRadius;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0.0, 20.0);
    self.layer.shadowRadius = 30.0;
    self.layer.shadowOpacity = kCardViewDefaultShadowOpacity;
  }
  
  [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight
                                                   relatedBy:NSLayoutRelationEqual
                                                      toItem:self attribute:NSLayoutAttributeWidth
                                                  multiplier:kCardViewAspectRatio constant:0.0]];
  
  //Default values
  [self updateBalance:[NSDecimalNumber decimalNumberWithString:@"0.0"] network:BlockchainNetworkTypeMainnet];
  
  self.layer.shouldRasterize = YES;
  self.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

/* $423.65 USD @ $746/ETH */
- (void) _updateUsdBalance {
  if (_ethBalance && _ethToUsdPrice) {
    NSDecimalNumber *usd = [_ethBalance decimalNumberByMultiplyingBy:_ethToUsdPrice];
    NSNumberFormatter *usdFormatter = [NSNumberFormatter usdFormatter];
    NSNumberFormatter *ethFormatter = [NSNumberFormatter ethereumFormatterWithNetwork:_network];
    NSString *usdBalance = [usdFormatter stringFromNumber:usd];
    NSString *ethUsdPrice = [usdFormatter stringFromNumber:_ethToUsdPrice];
    NSString *finalString = [NSString stringWithFormat:@"%@ USD @ %@/%@", usdBalance, ethUsdPrice, ethFormatter.currencySymbol];
    
    UIFont *balanceFont = nil;
    UIFont *infoFont = nil;
    if ([UIScreen mainScreen].screenSizeType == ScreenSizeTypeInches40) {
      balanceFont = [UIFont systemFontOfSize:13.0 weight:UIFontWeightMedium];
      infoFont = [UIFont systemFontOfSize:9.0 weight:UIFontWeightSemibold];
    } else {
      balanceFont = [UIFont systemFontOfSize:15.0 weight:UIFontWeightMedium];
      infoFont = [UIFont systemFontOfSize:11.0 weight:UIFontWeightSemibold];
    }
    
    NSDictionary *balanceAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor],
                                        NSFontAttributeName: balanceFont,
                                        NSKernAttributeName: @0.15};
    NSDictionary *infoAttributes = @{NSFontAttributeName: infoFont};
    NSMutableAttributedString *finalAttributedText = [[NSMutableAttributedString alloc] initWithString:finalString attributes:balanceAttributes];
    NSRange usdBalanceRange = [finalString rangeOfString:usdBalance];
    NSRange infoRange = NSMakeRange(NSMaxRange(usdBalanceRange), [finalString length] - NSMaxRange(usdBalanceRange));
    [finalAttributedText addAttributes:infoAttributes range:infoRange];
    self.usdBalanceLabel.attributedText = finalAttributedText;
    if (self.usdBalanceLabel.hidden) {
      self.usdBalanceLabel.hidden = NO;
    }
  }
}

- (UIView *) _prepareBackupWarningView {
  UIView *backupWarningView = [[UIView alloc] init];
  { //Backup view
    backupWarningView.translatesAutoresizingMaskIntoConstraints = NO;
    backupWarningView.backgroundColor = [UIColor sosoColor];
    backupWarningView.layer.cornerRadius = kCardViewDefaultCornerRadius / 2.0;
  }
  { //Backup content
    UIImageView *backupWarningImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"card_backup_warning"]];
    {
      backupWarningImageView.translatesAutoresizingMaskIntoConstraints = NO;
      [backupWarningView addSubview:backupWarningImageView];
      [backupWarningView addConstraint:[NSLayoutConstraint constraintWithItem:backupWarningImageView attribute:NSLayoutAttributeLeft
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:backupWarningView attribute:NSLayoutAttributeLeft
                                                                   multiplier:1.0 constant:kCardViewDefaultOffset / 2.0]];
      [backupWarningView addConstraint:[NSLayoutConstraint constraintWithItem:backupWarningImageView attribute:NSLayoutAttributeTop
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:backupWarningView attribute:NSLayoutAttributeTop
                                                                   multiplier:1.0 constant:kCardViewDefaultOffset / 2.0 + 1.0]];
    }
    UILabel *backupWarningLabel = [[UILabel alloc] init];
    {
      backupWarningLabel.translatesAutoresizingMaskIntoConstraints = NO;
      [backupWarningView addSubview:backupWarningLabel];
      [backupWarningView addConstraint:[NSLayoutConstraint constraintWithItem:backupWarningLabel attribute:NSLayoutAttributeLeft
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:backupWarningImageView attribute:NSLayoutAttributeRight
                                                                   multiplier:1.0 constant:kCardViewSmallOffset]];
      [backupWarningView addConstraint:[NSLayoutConstraint constraintWithItem:backupWarningImageView attribute:NSLayoutAttributeCenterY
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:backupWarningLabel attribute:NSLayoutAttributeCenterY
                                                                   multiplier:1.0 constant:0.0]];
      NSDictionary *attributes = @{NSForegroundColorAttributeName: [UIColor whiteColor],
                                   NSFontAttributeName: [UIFont systemFontOfSize:12.0 weight:UIFontWeightSemibold],
                                   NSKernAttributeName: @0.0};
      NSString *title = nil;
      if ([UIScreen mainScreen].screenSizeType == ScreenSizeTypeInches40) {
        title = NSLocalizedString(@"Action required", @"Card view: backup warning. 4.0 Inches");
      } else {
        title = NSLocalizedString(@"Action required: not backed up", @"Card view: backup warning");
      }
      
      backupWarningLabel.attributedText = [[NSAttributedString alloc] initWithString:title attributes:attributes];
    }
    UILabel *backupWarningDesciption = [[UILabel alloc] init];
    { //Backup warning description
      backupWarningDesciption.translatesAutoresizingMaskIntoConstraints = NO;
      backupWarningDesciption.alpha = 0.8;
      backupWarningDesciption.numberOfLines = 2;
      [backupWarningView addSubview:backupWarningDesciption];
      [backupWarningView addConstraint:[NSLayoutConstraint constraintWithItem:backupWarningImageView attribute:NSLayoutAttributeLeft
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:backupWarningDesciption attribute:NSLayoutAttributeLeft
                                                                   multiplier:1.0 constant:0.0]];
      [backupWarningView addConstraint:[NSLayoutConstraint constraintWithItem:backupWarningDesciption attribute:NSLayoutAttributeTop
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:backupWarningImageView attribute:NSLayoutAttributeBottom
                                                                   multiplier:1.0 constant:kCardViewSmallOffset]];
      [backupWarningView addConstraint:[NSLayoutConstraint constraintWithItem:backupWarningView attribute:NSLayoutAttributeBottom
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:backupWarningDesciption attribute:NSLayoutAttributeBottom
                                                                   multiplier:1.0 constant:kCardViewSmallOffset]];
      NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
      style.lineSpacing = 2.0;
      NSDictionary *attributes = @{NSForegroundColorAttributeName: [UIColor colorWithRGB:0xE6E6E6],
                                   NSFontAttributeName: [UIFont systemFontOfSize:12.0 weight:UIFontWeightRegular],
                                   NSKernAttributeName: @0.0,
                                   NSParagraphStyleAttributeName: style};
      
      NSString *title = nil;
      if ([UIScreen mainScreen].screenSizeType == ScreenSizeTypeInches40) {
        title = NSLocalizedString(@"If you lose this device you\nlose your account forever.", @"Card view: backup warning description. 4.0 Inches");
      } else {
        title = NSLocalizedString(@"If you lose this device you will lose\nyour account and all your funds forever.", @"Card view: backup warning description");
      }
      backupWarningDesciption.attributedText = [[NSAttributedString alloc] initWithString:title attributes:attributes];
    }
    { //Backup button
      UIButton *backupButton = [UIButton buttonWithType:UIButtonTypeSystem];
      [backupButton addTarget:self action:@selector(backupAction:) forControlEvents:UIControlEventTouchUpInside];
      [backupButton setContentEdgeInsets:UIEdgeInsetsMake(0.0, 12.0, 0.0, 12.0)];
      UIImage *backgroundImage = [[UIImage imageWithColor:[UIColor whiteColor]
                                                     size:CGSizeMake(28.0, 28.0) cornerRadius:14.0] resizableImageWithCapInsets:UIEdgeInsetsMake(14.0, 14.0, 14.0, 14.0)];
      [backupButton setBackgroundImage:backgroundImage forState:UIControlStateNormal];
      backupButton.translatesAutoresizingMaskIntoConstraints = NO;
      [backupWarningView addSubview:backupButton];
      
      [backupWarningView addConstraint:[NSLayoutConstraint constraintWithItem:backupWarningView attribute:NSLayoutAttributeRight
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:backupButton attribute:NSLayoutAttributeRight
                                                                   multiplier:1.0 constant:kCardViewDefaultOffset / 2.0]];
      [backupWarningView addConstraint:[NSLayoutConstraint constraintWithItem:backupButton attribute:NSLayoutAttributeCenterY
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:backupWarningView attribute:NSLayoutAttributeCenterY
                                                                   multiplier:1.0 constant:0.0]];
      
      NSDictionary *attributes = @{NSForegroundColorAttributeName: [UIColor sosoColor],
                                   NSFontAttributeName: [UIFont systemFontOfSize:13.0 weight:UIFontWeightBold],
                                   NSKernAttributeName: @0.3};
      NSString *title = NSLocalizedString(@"BACK UP", @"Card view: backup button title");
      [backupButton setAttributedTitle:[[NSAttributedString alloc] initWithString:title attributes:attributes] forState:UIControlStateNormal];
    }
  }
  return backupWarningView;
}

- (UIView *) _prepareBackupOkView {
  UIView *backupOkView = [[UIView alloc] init];
  { //Backup view
    backupOkView.translatesAutoresizingMaskIntoConstraints = NO;
    backupOkView.backgroundColor = [UIColor clearColor];
    backupOkView.layer.cornerRadius = kCardViewDefaultCornerRadius / 2.0;
  }
  { //Backup content
    UIImageView *backupOkImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"card_backup_ok"]];
    {
      backupOkImageView.translatesAutoresizingMaskIntoConstraints = NO;
      [backupOkView addSubview:backupOkImageView];
      [backupOkView addConstraint:[NSLayoutConstraint constraintWithItem:backupOkImageView attribute:NSLayoutAttributeLeft
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:backupOkView attribute:NSLayoutAttributeLeft
                                                              multiplier:1.0 constant:kCardViewDefaultOffset / 2.0]];
      NSDictionary *views = @{@"icon": backupOkImageView};
      [backupOkView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[icon]|" options:0 metrics:nil views:views]];
    }
    { //Backup button
      UIButton *backupButton = [InlineButton inlineButtonWithChevron:NO];
      backupButton.userInteractionEnabled = NO;
      [backupButton addTarget:self action:@selector(backupStatusAction:) forControlEvents:UIControlEventTouchUpInside];
      backupButton.translatesAutoresizingMaskIntoConstraints = NO;
      [backupOkView addSubview:backupButton];
      
      NSDictionary *metrics = @{@"HOFFSET": @(kCardViewDefaultOffset / 2.0)};
      NSDictionary *views = @{@"icon": backupOkImageView,
                              @"button": backupButton};
      
      [backupOkView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[icon]-(HOFFSET)-[button]|" options:NSLayoutFormatDirectionLeftToRight metrics:metrics views:views]];
      
      [backupOkView addConstraint:[NSLayoutConstraint constraintWithItem:backupButton attribute:NSLayoutAttributeCenterY
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:backupOkImageView attribute:NSLayoutAttributeCenterY
                                                              multiplier:1.0 constant:0.0]];
      
      NSDictionary *attributes = @{NSForegroundColorAttributeName: [UIColor whiteColor],
                                   NSFontAttributeName: [UIFont systemFontOfSize:12.0 weight:UIFontWeightSemibold],
                                   NSKernAttributeName: @0.0};
      NSString *title = NSLocalizedString(@"Backed up", @"Card view: backed up button title");
      [backupButton setAttributedTitle:[[NSAttributedString alloc] initWithString:title attributes:attributes] forState:UIControlStateNormal];
    }
  }
  return backupOkView;
}

#pragma mark - IBActions

- (void) shareAction:(__unused UIButton *)sender {
  [self.delegate cardViewDidTouchShareButton:self];
}

- (void) backupAction:(__unused UIButton *)sender {
  [self.delegate cardViewDidTouchBackupButton:self];
}

- (void) backupStatusAction:(__unused UIButton *)sender {
  [self.delegate cardViewDidTouchBackupStatusButton:self];
}

@end
