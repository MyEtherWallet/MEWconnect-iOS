//
//  BannerView.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 3/6/20.
//  Copyright © 2020 MyEtherWallet, Inc. All rights reserved.
//

@import Lottie;
@import libextobjc.EXTScope;

#import "BannerView.h"
#import "UIImage+Color.h"
#import "UIColor+Application.h"
#import "UIScreen+ScreenSizeType.h"

static UIEdgeInsets BannerViewContentInsets = {20.0, 20.0, 20.0, 20.0};
static UIEdgeInsets TitleInsets = {0.0, 0.0, 0.0, 0.0};
static UIEdgeInsets AnimationInsets = {11.0, 0.0, 0.0, 10.0};
static UIEdgeInsets DescriptionInsets = {11.0, 10.0, 0.0, 0.0};
static UIEdgeInsets ButtonInsets = {11.0, 0.0, 0.0, 0.0};

@interface BannerView ()
@property (nonatomic, weak) UIImageView *backgroundImageView;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UILabel *descriptionLabel;
@property (nonatomic, weak) LOTAnimationView *animationView;
@property (nonatomic, weak) UIButton *appButton;
@end

@implementation BannerView {
  CGSize _size;
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

- (void)dealloc {
  [self stopAnimation];
}

#pragma mark - Private

- (void) _commonInit {
  self.translatesAutoresizingMaskIntoConstraints = NO;
  { //Background
    UIImage *backgroundImage = [[UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(20.0, 20.0) cornerRadius:16.0] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:backgroundImage];
    backgroundImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:backgroundImageView];
    NSDictionary *views = @{
      @"BACKGROUND": backgroundImageView
    };
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[BACKGROUND]|" options:NSLayoutFormatDirectionLeftToRight metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[BACKGROUND]|" options:NSLayoutFormatDirectionLeftToRight metrics:nil views:views]];
    self.backgroundImageView = backgroundImageView;
  }
  UILabel *titleLabel;
  { //title
    titleLabel = [[UILabel alloc] init];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.numberOfLines = 0;
    [self addSubview:titleLabel];
    
    NSDictionary *metrics = @{
      @"LOFFSET": @(BannerViewContentInsets.left + TitleInsets.left),
      @"ROFFSET": @(BannerViewContentInsets.right + TitleInsets.right),
      @"TOFFSET": @(BannerViewContentInsets.top + TitleInsets.top)
    };
    NSDictionary *views = @{
      @"TITLE": titleLabel
    };
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(LOFFSET)-[TITLE]-(ROFFSET)-|" options:NSLayoutFormatDirectionLeftToRight metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(TOFFSET)-[TITLE]" options:NSLayoutFormatDirectionLeftToRight metrics:metrics views:views]];
    
    _titleLabel = titleLabel;
  }
  LOTAnimationView *animationView;
  { //animation
    animationView = [LOTAnimationView animationNamed:@"banner_animation"];
    animationView.translatesAutoresizingMaskIntoConstraints = NO;
    animationView.loopAnimation = NO;
    [self addSubview:animationView];
    
    NSMutableDictionary *metrics = [@{
      @"LOFFSET": @(BannerViewContentInsets.left + AnimationInsets.left),
      @"TOFFSET": @(TitleInsets.bottom + AnimationInsets.top),
      @"HEIGHT": @96.0,
      @"WIDTH": @96.0
    } mutableCopy];
    
    switch ([UIScreen mainScreen].screenSizeType) {
      case ScreenSizeTypeInches35:
      case ScreenSizeTypeInches40:
        metrics[@"HEIGHT"] = @70.0;
        metrics[@"WIDTH"] = @70.0;
        break;
      default:
        break;
    }
    NSDictionary *views = @{
      @"ANIMATION_VIEW": animationView,
      @"TITLE": titleLabel
    };
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(LOFFSET)-[ANIMATION_VIEW(==HEIGHT)]" options:NSLayoutFormatDirectionLeftToRight metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[TITLE]-(TOFFSET)-[ANIMATION_VIEW(==WIDTH)]" options:NSLayoutFormatDirectionLeftToRight metrics:metrics views:views]];
    
    _animationView = animationView;
  }
  UILabel *descriptionLabel;
  { //description
    descriptionLabel = [[UILabel alloc] init];
    descriptionLabel.numberOfLines = 0;
    descriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:descriptionLabel];
    
    NSMutableDictionary *metrics = [@{
      @"LOFFSET": @(AnimationInsets.right + DescriptionInsets.left),
      @"ROFFSET": @(BannerViewContentInsets.right + DescriptionInsets.right),
      @"TOFFSET": @(TitleInsets.bottom + DescriptionInsets.top)
    } mutableCopy];
    switch ([UIScreen mainScreen].screenSizeType) {
      case ScreenSizeTypeInches35:
      case ScreenSizeTypeInches40:
        metrics[@"LOFFSET"] = @(fabs(AnimationInsets.right / 2.0 + DescriptionInsets.left));
        break;
      default:
        break;
    }
    
    NSDictionary *views = @{
      @"ANIMATION_VIEW": animationView,
      @"TITLE": titleLabel,
      @"DESCRIPTION": descriptionLabel
    };
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[ANIMATION_VIEW]-(LOFFSET)-[DESCRIPTION]-(ROFFSET)-|" options:NSLayoutFormatDirectionLeftToRight metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[TITLE]-(TOFFSET)-[DESCRIPTION]" options:NSLayoutFormatDirectionLeftToRight metrics:metrics views:views]];
    
    _descriptionLabel = descriptionLabel;
  }
  UIButton *button;
  { //button
    button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:button];
    
    NSDictionary *metrics = @{
      @"LOFFSET": @(BannerViewContentInsets.left + ButtonInsets.left),
      @"ROFFSET": @(BannerViewContentInsets.right + ButtonInsets.right),
      @"TOFFSET": @(DescriptionInsets.bottom + ButtonInsets.top),
      @"BOFFSET": @(BannerViewContentInsets.bottom + ButtonInsets.bottom)
    };
    NSDictionary *views = @{
      @"DESCRIPTION": descriptionLabel,
      @"ANIMATION_VIEW": animationView,
      @"BUTTON": button
    };
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(LOFFSET)-[BUTTON]-(ROFFSET)-|" options:NSLayoutFormatDirectionLeftToRight metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[DESCRIPTION]-(>=TOFFSET@999)-[BUTTON]-(BOFFSET)-|" options:NSLayoutFormatDirectionLeftToRight metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[ANIMATION_VIEW]-(>=TOFFSET@999)-[BUTTON]-(BOFFSET)-|" options:NSLayoutFormatDirectionLeftToRight metrics:metrics views:views]];
    
    _appButton = button;
  }
  
  self.backgroundColor = [UIColor clearColor];
  
  self.titleLabel.text = NSLocalizedString(@"MEW wallet app is now available", @"Banner view");
  
  NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
  style.lineSpacing = 2.0;
  NSDictionary *attributes;
  
  switch ([UIScreen mainScreen].screenSizeType) {
    case ScreenSizeTypeInches35:
    case ScreenSizeTypeInches40: {
      self.titleLabel.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightSemibold];
      attributes = @{
        NSFontAttributeName: [UIFont systemFontOfSize:12.0 weight:UIFontWeightRegular],
        NSForegroundColorAttributeName: [UIColor bannerDescriptionColor],
        NSParagraphStyleAttributeName: style
      };
      break;
    }
    default: {
      self.titleLabel.font = [UIFont systemFontOfSize:20.0 weight:UIFontWeightSemibold];
      attributes = @{
        NSFontAttributeName: [UIFont systemFontOfSize:15.0 weight:UIFontWeightRegular],
        NSForegroundColorAttributeName: [UIColor bannerDescriptionColor],
        NSParagraphStyleAttributeName: style
      };
      break;
    }
  }
  
  NSAttributedString *attributedDescription = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"A fully fledged mobile wallet that works with your existing MEWconnect account.\nDownload the app to upgrade.", @"Banner view")
                                                                              attributes:attributes];
  self.descriptionLabel.attributedText = attributedDescription;
  [self.appButton setTitle:[NSLocalizedString(@"Free upgrade", @"Banner view") uppercaseString] forState:UIControlStateNormal];
  [self.appButton setTitleColor:[UIColor mainApplicationColor] forState:UIControlStateNormal];
  self.appButton.titleLabel.font = [UIFont systemFontOfSize:15.0 weight:UIFontWeightSemibold];
  [self.appButton setBackgroundImage:[[UIImage imageWithColor:[UIColor backgroundLightBlue] size:CGSizeMake(40.0, 40.0) cornerRadius:10.0] stretchableImageWithLeftCapWidth:20.0 topCapHeight:20.0]
                            forState:UIControlStateNormal];
  [self.appButton addTarget:self action:@selector(openAppAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)invalidateIntrinsicContentSize {
  _size = CGSizeZero;
}

- (CGSize)intrinsicContentSize {
  if (CGSizeEqualToSize(_size, CGSizeZero)) {
    _size = [self sizeThatFits:CGSizeMake(CGRectGetWidth(self.frame), 10000.0)];
  }
  return _size;
}

- (IBAction)openAppAction:(__unused id)sender {
  if (self.actionBlock) {
    self.actionBlock();
  }
}

#pragma mark - Public

- (void) playAnimation {
  [NSObject cancelPreviousPerformRequestsWithTarget:self];
  [self _playAnimation];
}

- (void) stopAnimation {
  [self.animationView stop];
  [self.animationView setAnimationProgress:0.0];
  [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

#pragma mark - Private

- (void) _playAnimation {
  @weakify(self);
  [self.animationView playWithCompletion:^(BOOL __unused animationFinished) {
    @strongify(self);
    if (self && animationFinished) {
      NSTimeInterval delay = arc4random() % 10 + 20.0;
      [self performSelector:@selector(playAnimation) withObject:nil afterDelay:delay];
    }
  }];
}

@end
