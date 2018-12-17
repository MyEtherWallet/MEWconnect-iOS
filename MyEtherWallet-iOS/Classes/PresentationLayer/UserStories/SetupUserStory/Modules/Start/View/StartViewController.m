//
//  StartViewController.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 14/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import CHIPageControl.Swift;

#import "StartViewController.h"

#import "StartViewOutput.h"

#import "UIImage+MEWBackground.h"
#import "UIImage+Color.h"
#import "UIBezierPath+Morphing.h"
#import "UIScreen+ScreenSizeType.h"

static NSUInteger kStartViewIconMinimumCorners  = 4;

@interface StartViewController () <UIScrollViewDelegate>
@property (nonatomic, weak) IBOutlet UIButton *createNewWalletButton;
@property (nonatomic, weak) IBOutlet UIButton *restoreWalletButton;
@property (nonatomic, weak) IBOutlet UILabel *byMyEtherWalletTitle;
@property (nonatomic, weak) IBOutlet CHIPageControlChimayo *pageControl;
@property (nonatomic, weak) IBOutlet UIView *morphingIconContainer;
@property (nonatomic, strong) IBOutletCollection(UILabel) NSArray <UILabel *> *pageDescriptions;
@property (nonatomic, weak) IBOutlet UIImageView *mewConnectLogo;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *mewConnectLogoTopOffsetConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *morphingIconContrainerTopOffsetConstraint;;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *morphingIconContrainerCenterXConstraint;
@property (nonatomic, weak) CAShapeLayer *morphLayer;
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
  [self _prepareDescriptions];
  switch ([UIScreen mainScreen].screenSizeType) {
    case ScreenSizeTypeInches40: {
      [self.mewConnectLogo setImage:[UIImage imageNamed:@"intro_mewconnect_logo_40"]];
      self.mewConnectLogoTopOffsetConstraint.constant = 79.0;
      self.morphingIconContrainerTopOffsetConstraint.constant = -40.0;
      break;
    }
    case ScreenSizeTypeInches58: {
      self.mewConnectLogoTopOffsetConstraint.constant = 79.0;
      break;
    }
      
    default:
      break;
  }
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
  [self.view layoutIfNeeded];
  [self _prepareIconAnimation];
  self.morphingIconContrainerCenterXConstraint.constant = CGRectGetWidth(self.view.bounds);
}

#pragma mark - IBActions

- (IBAction) createNewWallet:(__unused UIButton *)sender {
  [self.output createNewWalletAction];
}

- (IBAction) restoreWallet:(__unused UIButton *)sender {
  [self.output restoreWallet];
}

- (IBAction)unwindToStart:(__unused UIStoryboardSegue *)sender {}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  CGFloat xOffset = scrollView.contentOffset.x;
  CGFloat maxXOffset = CGRectGetMaxX(scrollView.bounds);
  
  CGFloat pageWidth = CGRectGetWidth(scrollView.bounds);
  CGFloat fPage = xOffset / pageWidth;
  self.pageControl.progress = fPage;
  
  if (scrollView.contentOffset.x < pageWidth) {
    self.morphingIconContrainerCenterXConstraint.constant = pageWidth - xOffset;
    self.morphLayer.timeOffset = 0.0;
  } else if (maxXOffset > scrollView.contentSize.width) {
    self.morphingIconContrainerCenterXConstraint.constant = scrollView.contentSize.width - maxXOffset;
    self.morphLayer.timeOffset = 1.0;
  } else {
    self.morphingIconContrainerCenterXConstraint.constant = 0.0;
    self.morphLayer.timeOffset = MIN(1.0, MAX(0.0, (xOffset - pageWidth) / (scrollView.contentSize.width - 2.0 * pageWidth)));
  }
}

#pragma mark - Private

- (void) _prepareDescriptions {
  NSArray *descriptions = @[NSLocalizedString(@"Finally, a ‘hardware wallet’ without all the hardware. Officially by MyEtherWallet", @"Intro. Page 1 description"),
                            NSLocalizedString(@"Secure your every MyEtherWallet transaction with two-factor verification", @"Intro. Page 2 description"),
                            NSLocalizedString(@"Store your private keys safely in a local isolated secure vault on your device", @"Intro. Page 3 description"),
                            NSLocalizedString(@"Protect yourself from phishers and malware. No one can obtain your private key.", @"Intro. Page 4 description"),
                            NSLocalizedString(@"No data collection: MyEtherWallet can’t collect your personal data even if we wanted to.", @"Intro. Page 5 description"),
                            NSLocalizedString(@"No centralized servers for communication.\nNo databases. MEWconnect uses P2P instead.", @"Intro. Page 6 description"),
                            NSLocalizedString(@"Transparent, free and open source. Audited by the community", @"Intro. Page 7 description")];
  
  NSArray *descriptionBoldParts = @[NSLocalizedString(@"", @"Intro. Page 1 description bold part"),
                                    NSLocalizedString(@"Secure", @"Intro. Page 2 description bold part"),
                                    NSLocalizedString(@"Store", @"Intro. Page 3 description bold part"),
                                    NSLocalizedString(@"Protect", @"Intro. Page 4 description bold part"),
                                    NSLocalizedString(@"", @"Intro. Page 5 description bold part"),
                                    NSLocalizedString(@"", @"Intro. Page 6 description bold part"),
                                    NSLocalizedString(@"", @"Intro. Page 7 description bold part")];
  NSAssert([descriptions count] == [descriptionBoldParts count], @"Incorrect configuration");
  NSAssert([self.pageDescriptions count] == [descriptions count], @"Incorrect configuration");
  NSArray *sortedLabels = [self.pageDescriptions sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:NSStringFromSelector(@selector(tag)) ascending:YES]]];
  for (NSInteger idx = 0; idx < [sortedLabels count]; ++idx) {
    UILabel *label = sortedLabels[idx];
    NSString *text = descriptions[idx];
    NSArray <NSString *> *boldParts = [descriptionBoldParts[idx] componentsSeparatedByString:@"|"];
    label.attributedText = [self _prepareDescription:text boldParts:boldParts];
  }
}

- (NSAttributedString *) _prepareDescription:(NSString *)description boldParts:(NSArray <NSString *> *)boldParts {
  if (!description) {
    return [[NSAttributedString alloc] init];
  }
  NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
  CGFloat fontSize = 26.0;
  if ([UIScreen mainScreen].screenSizeType == ScreenSizeTypeInches40) {
    fontSize = 20.0;
    style.minimumLineHeight = 28.0;
    style.maximumLineHeight = 28.0;
  } else {
    style.minimumLineHeight = 34.0;
    style.maximumLineHeight = 34.0;
  }
  

  NSDictionary *attributes = @{NSForegroundColorAttributeName: [UIColor whiteColor],
                               NSFontAttributeName: [UIFont systemFontOfSize:fontSize weight:UIFontWeightMedium],
                               NSParagraphStyleAttributeName: style};
  NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:description attributes:attributes];
  //Change font of semibold parts
  for (NSString *bold in boldParts) {
    NSRange range = [description rangeOfString:bold];
    if (range.location != NSNotFound) {
      [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:fontSize weight:UIFontWeightBold] range:range];
    }
  }
  [attributedString fixAttributesInRange:NSMakeRange(0, [attributedString length])];
  return [attributedString copy];
}

- (void) _prepareIconAnimation {
  CALayer *iconLayer = nil;
  if (!_morphLayer) {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [self.morphingIconContainer.layer addSublayer:shapeLayer];
    shapeLayer.frame = self.morphingIconContainer.bounds;
    _morphLayer = shapeLayer;
    _morphLayer.speed = 0.0;
    _morphLayer.strokeColor = [UIColor whiteColor].CGColor;
    _morphLayer.lineWidth = 10.0;
    _morphLayer.lineJoin = kCALineJoinRound;
    
    iconLayer = [CALayer layer];
    [_morphLayer addSublayer:iconLayer];
    
    UIImage *firstIconFrame = [UIImage imageNamed:@"intro_secure_icon"];
    CGRect frame = _morphLayer.bounds;
    frame.size = firstIconFrame.size;
    frame.origin = CGPointMake((CGRectGetWidth(_morphLayer.bounds) - CGRectGetWidth(frame)) / 2.0,
                               (CGRectGetHeight(_morphLayer.bounds) - CGRectGetHeight(frame)) / 2.0);
    iconLayer.frame = frame;
  } else {
    iconLayer = [[_morphLayer sublayers] firstObject];
  }
  
  CAKeyframeAnimation *pathAnimation = nil;
  CAKeyframeAnimation *rotateAnimation = nil;
  CAKeyframeAnimation *fillAnimation = nil;
  CAKeyframeAnimation *imageAnimation = nil;
  
  NSInteger numberOfPages = self.pageControl.numberOfPages - 1; //Minus start page
  
  { //Path Animation
    NSInteger minCorners = kStartViewIconMinimumCorners;
    NSInteger maxCorners = minCorners + numberOfPages * 2;
    
    NSMutableArray *values = [[NSMutableArray alloc] initWithCapacity:numberOfPages];
    NSMutableArray <NSNumber *> *times = [[NSMutableArray alloc] initWithCapacity:numberOfPages];
    for (NSUInteger pageIdx = 0; pageIdx < numberOfPages; ++pageIdx) {
      UIBezierPath *path = [UIBezierPath segmentedPathWithSize:self.morphingIconContainer.frame.size numberOfCorners:minCorners + pageIdx * 2 numberOfMorphCorners:maxCorners];
      [values addObject:(__bridge id)path.CGPath];
      [times addObject:@((CGFloat)pageIdx / (CGFloat)(numberOfPages - 1))];
    }
    
    pathAnimation = [CAKeyframeAnimation animationWithKeyPath:NSStringFromSelector(@selector(path))];
    pathAnimation.values = values;
    pathAnimation.keyTimes = times;
    pathAnimation.duration = 1.0;
    pathAnimation.fillMode = kCAFillModeForwards;
  }
  { //Rotate Animation
    static NSUInteger stepsPerRotate = 4;
    
    CGFloat angleStep = (M_PI * 2.0) / (CGFloat)stepsPerRotate;
    CGFloat currentAngle = 0.0;
    
    NSMutableArray *values = [[NSMutableArray alloc] initWithCapacity:numberOfPages];
    NSMutableArray <NSNumber *> *times = [[NSMutableArray alloc] initWithCapacity:numberOfPages];
    CGFloat rangeMinTime = 0.0;
    CGFloat rangeMaxTime = 0.0;
    for (NSUInteger pageIdx = 0; pageIdx < numberOfPages; ++pageIdx) {
      rangeMaxTime = (CGFloat)(pageIdx + 1) / (CGFloat)(numberOfPages - 1);
      CGFloat timeStep = (rangeMaxTime - rangeMinTime) / (CGFloat)stepsPerRotate;
      for (NSUInteger rotateStep = 0; rotateStep < stepsPerRotate; ++rotateStep) {
        [values addObject:@(currentAngle)];
        CGFloat timeKey = rangeMinTime + timeStep * rotateStep;
        [times addObject:@(timeKey)];
        currentAngle += angleStep;
      }
      rangeMinTime = rangeMaxTime;
    }
    
    rotateAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotateAnimation.values = values;
    rotateAnimation.keyTimes = times;
    rotateAnimation.duration = 1.0;
    rotateAnimation.fillMode = kCAFillModeForwards;
  }
  { //Fill Animation
    NSArray *clearSteps = @[@3];
    NSMutableArray *values = [[NSMutableArray alloc] initWithCapacity:numberOfPages];
    NSMutableArray <NSNumber *> *times = [[NSMutableArray alloc] initWithCapacity:numberOfPages];
    for (NSUInteger pageIdx = 0; pageIdx < numberOfPages; ++pageIdx) {
      if ([clearSteps indexOfObject:@(pageIdx)] != NSNotFound) {
        [values addObject:(__bridge id)[UIColor clearColor].CGColor];
      } else {
        [values addObject:(__bridge id)[UIColor whiteColor].CGColor];
      }
      [times addObject:@((CGFloat)pageIdx / (CGFloat)(numberOfPages - 1))];
    }
    
    fillAnimation = [CAKeyframeAnimation animationWithKeyPath:@"fillColor"];
    fillAnimation.values = values;
    fillAnimation.keyTimes = times;
    fillAnimation.duration = 1.0;
    fillAnimation.fillMode = kCAFillModeForwards;
  }
  { //Icon image
    NSArray *imageNames = @[@"intro_secure_icon", @"intro_safe_icon", @"intro_protect_icon", @"", @"intro_p2p_icon", @"intro_community_icon"];
    NSMutableArray *values = [[NSMutableArray alloc] initWithCapacity:numberOfPages];
    NSMutableArray <NSNumber *> *times = [[NSMutableArray alloc] initWithCapacity:numberOfPages];
    for (NSUInteger pageIdx = 0; pageIdx < numberOfPages; ++pageIdx) {
      NSString *name = imageNames[pageIdx];
      if ([name isEqualToString:@""]) {
        [values addObject:(__bridge id)[UIImage imageWithColor:[UIColor clearColor]].CGImage];
      } else {
        [values addObject:(__bridge id)[UIImage imageNamed:name].CGImage];
      }
      [times addObject:@((CGFloat)pageIdx / (CGFloat)(numberOfPages - 1))];
    }
    
    imageAnimation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
    imageAnimation.values = values;
    imageAnimation.keyTimes = times;
    imageAnimation.duration = 1.0;
    imageAnimation.removedOnCompletion = NO;
    imageAnimation.fillMode = kCAFillModeForwards;
  }
  
  CAAnimationGroup *group = [CAAnimationGroup animation];
  group.duration = 1.0;
  group.animations = @[pathAnimation, rotateAnimation, fillAnimation];
  group.fillMode = kCAFillModeForwards;
  group.removedOnCompletion = NO;
  [_morphLayer addAnimation:group forKey:@"animation"];
  
  [iconLayer addAnimation:imageAnimation forKey:@"animation"];
}

@end
