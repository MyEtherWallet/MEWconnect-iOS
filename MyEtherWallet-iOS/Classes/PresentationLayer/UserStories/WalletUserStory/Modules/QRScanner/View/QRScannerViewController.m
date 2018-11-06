//
//  QRScannerViewController.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import AVFoundation;
@import MessageUI;

#import "QRScannerViewController.h"

#import "QRScannerViewOutput.h"

#import "LinkedLabel.h"

#import "UIColor+Application.h"
#import "UIColor+Hex.h"
#import "UIScreen+ScreenSizeType.h"

#import "UIView+LockFrame.h"

static CFTimeInterval kQRScannerViewControllerOpacityAnimationDuration = 0.4;
static NSTimeInterval kQRScannerViewControllerFadeAnimationDuration    = 0.25;

@interface QRScannerViewController () <AVCaptureMetadataOutputObjectsDelegate, LinkedLabelDelegate, MFMailComposeViewControllerDelegate>
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *stepsDescriptionLabel;
@property (nonatomic, weak) IBOutlet UIButton *closeButton;
@property (nonatomic, weak) IBOutlet UIImageView *focusViewTR;
@property (nonatomic, weak) IBOutlet UIImageView *focusViewBL;
@property (nonatomic, weak) IBOutlet UIImageView *focusViewBR;
@property (nonatomic, weak) IBOutlet UIView *cameraContainerView;

@property (nonatomic, weak) IBOutlet UIView *loadingContainerView;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *loadingActivity;

@property (nonatomic, weak) IBOutlet UIView *statusContainerView;
@property (nonatomic, weak) IBOutlet UIImageView *statusInfoIconImageView;
@property (nonatomic, weak) IBOutlet UILabel *statusInfoTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *statusInfoDescriptionLabel;
@property (nonatomic, weak) IBOutlet UIButton *statusInfoContactSupportButton;

@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;

@property (nonatomic, weak) IBOutlet LinkedLabel *accessToCameraLabel;

@property (nonatomic) NSInteger runningAnimations;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *cameraContainerHeightConstraint;
@property (nonatomic, strong) IBOutletCollection(NSLayoutConstraint) NSArray <NSLayoutConstraint *> *focusViewYOffsetConstraints;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *cameraToDescriptionYOffsetConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *descriptionRightOffsetConstraint;
@end

@implementation QRScannerViewController

#pragma mark - LifeCycle

- (void) viewDidLoad {
	[super viewDidLoad];

	[self.output didTriggerViewReadyEvent];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.output didTriggerViewWillAppear];
}

- (void) viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [self.output didTriggerViewDidAppear];
  self.view.lockFrame = YES;
}

- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
  [self.output didTriggerViewDidDisappear];
  [self.loadingActivity stopAnimating];
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
  self.videoPreviewLayer.frame = self.cameraContainerView.bounds;
}

- (void)viewLayoutMarginsDidChange {
  [super viewLayoutMarginsDidChange];
  [self _updatePrefferedContentSize];
}

#pragma mark - Override

- (void)setCustomTransitioningDelegate:(id<UIViewControllerTransitioningDelegate>)customTransitioningDelegate {
  _customTransitioningDelegate = customTransitioningDelegate;
  self.transitioningDelegate = customTransitioningDelegate;
}

#pragma mark - QRScannerViewInput

- (void) setupInitialState {
  if ([UIScreen mainScreen].screenSizeType == ScreenSizeTypeInches40) {
    self.cameraContainerHeightConstraint.constant = -19.0;
    for (NSLayoutConstraint *constraint in self.focusViewYOffsetConstraints) {
      constraint.constant = 18.0;
    }
    self.cameraToDescriptionYOffsetConstraint.constant = 17.0;
    self.descriptionRightOffsetConstraint.constant = 20.0;
  }
  if ([UIScreen mainScreen].screenSizeType == ScreenSizeTypeInches40 ||
      ![MFMailComposeViewController canSendMail]) {
    [self.statusInfoContactSupportButton removeFromSuperview];
    [self.statusInfoDescriptionLabel.bottomAnchor constraintEqualToAnchor:self.statusInfoDescriptionLabel.superview.bottomAnchor].active = YES;
  } else {
    NSDictionary *attributes = @{NSFontAttributeName: self.statusInfoContactSupportButton.titleLabel.font,
                                 NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
    NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Contact support", @"QRScanner. Connect error. Contact support")
                                                                          attributes:attributes];
    [self.statusInfoContactSupportButton setAttributedTitle:attributedTitle forState:UIControlStateNormal];
  }
  [self _prepareStepsDescription];
  { //title label
    NSDictionary *attributes = @{NSFontAttributeName: self.titleLabel.font,
                                 NSForegroundColorAttributeName: self.titleLabel.textColor,
                                 NSKernAttributeName: @(-0.12)};
    self.titleLabel.attributedText = [[NSAttributedString alloc] initWithString:self.titleLabel.text attributes:attributes];
  }
  { //close button
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentCenter;
    NSDictionary *attributes = @{NSFontAttributeName: self.closeButton.titleLabel.font,
                                 NSForegroundColorAttributeName: [self.closeButton titleColorForState:UIControlStateNormal],
                                 NSParagraphStyleAttributeName: style,
                                 NSKernAttributeName: @(0.6)};
    [self.closeButton setAttributedTitle:[[NSAttributedString alloc] initWithString:[self.closeButton titleForState:UIControlStateNormal]
                                                                         attributes:attributes]
                                forState:UIControlStateNormal];
  }
  {
    self.focusViewTR.layer.transform = CATransform3DMakeScale(-1.0, 1.0, 1.0);
    self.focusViewBL.layer.transform = CATransform3DMakeScale(1.0, -1.0, 1.0);
    self.focusViewBR.layer.transform = CATransform3DMakeScale(-1.0, -1.0, 1.0);
  }
  { //Access to camera
    NSString *text = NSLocalizedString(@"Please enable camera access for MEWconnect in Settings", @"QR Scanner. Access to camera warning");
    NSArray <NSString *> *linkedParts = [NSLocalizedString(@"Settings", @"QR Scanner. Access to camera warning. Linked parts") componentsSeparatedByString:@"|"];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 5.0;
    style.alignment = self.accessToCameraLabel.textAlignment;
    NSDictionary *attributes = @{NSFontAttributeName: self.accessToCameraLabel.font,
                                 NSForegroundColorAttributeName: self.accessToCameraLabel.textColor,
                                 NSParagraphStyleAttributeName: style,
                                 NSKernAttributeName: @(-0.01)};
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
    for (NSString *part in linkedParts) {
      NSRange range = [attributedString.string rangeOfString:part];
      if (range.location != NSNotFound && range.length > 0) {
        NSDictionary *linkAttributes = @{NSUnderlineColorAttributeName: [UIColor whiteColor],
                                         NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),
                                         NSLinkAttributeName: [NSURL URLWithString:@"http://dummy.url"],
                                         NSForegroundColorAttributeName: [UIColor whiteColor]};
        [attributedString addAttributes:linkAttributes range:range];
      }
    }
    
    self.accessToCameraLabel.attributedText = attributedString;
  }
  [self _updatePrefferedContentSize];
}

- (void)updateWithCaptureSession:(AVCaptureSession *)captureSession {
  if (self.videoPreviewLayer) {
    [self.videoPreviewLayer removeFromSuperlayer];
  }
  { //Video preview
    self.videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:captureSession];
    [self.videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [self.cameraContainerView.layer addSublayer:self.videoPreviewLayer];
    self.videoPreviewLayer.frame = self.cameraContainerView.bounds;
    self.videoPreviewLayer.opacity = 0.0;
  }
}

- (void)animateVideoPreview {
  if (self.videoPreviewLayer.opacity < 1.0) {
    [CATransaction begin];
    [CATransaction setAnimationDuration:kQRScannerViewControllerOpacityAnimationDuration];
    self.videoPreviewLayer.opacity = 1.0;
    [CATransaction commit];
  }
}

- (void)showLoading {
  [self.loadingActivity startAnimating];
  self.loadingContainerView.alpha = 0.0;
  ++self.runningAnimations;
  [UIView animateWithDuration:kQRScannerViewControllerFadeAnimationDuration animations:^{
    self.stepsDescriptionLabel.alpha = 0.0;
    self.statusContainerView.alpha = 0.0;
    self.loadingContainerView.alpha = 1.0;
  } completion:^(__unused BOOL finished) {
    --self.runningAnimations;
  }];
}

- (void) showError {
  self.statusInfoIconImageView.image = [UIImage imageNamed:@"scan_error_icon"];
  self.statusInfoTitleLabel.text = NSLocalizedString(@"Something went wrong", @"QRScanner. Connection error title");
  self.statusInfoContactSupportButton.hidden = NO;
  {
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentCenter;
    style.lineSpacing = 2.0;
    NSDictionary *attributes = @{NSForegroundColorAttributeName: self.statusInfoDescriptionLabel.textColor,
                                 NSFontAttributeName: self.statusInfoDescriptionLabel.font,
                                 NSParagraphStyleAttributeName: style};
    NSString *text = NSLocalizedString(@"Please try again or use a\ndifferent QR code.", @"QRScanner. Connection error description");
    self.statusInfoDescriptionLabel.attributedText = [[NSAttributedString alloc] initWithString:text attributes:attributes];
  }
  
  ++self.runningAnimations;
  [UIView animateWithDuration:kQRScannerViewControllerFadeAnimationDuration
                   animations:^{
                     self.stepsDescriptionLabel.alpha = 0.0;
                     self.loadingContainerView.alpha = 0.0;
                     self.statusContainerView.alpha = 1.0;
                     self.statusInfoContactSupportButton.alpha = 1.0;
                   } completion:^(__unused BOOL finished) {
                     --self.runningAnimations;
                     if (self.runningAnimations == 0) {
                       [self.loadingActivity stopAnimating];
                     }
                   }];
}

- (void) showSuccess {
  self.statusInfoIconImageView.image = [UIImage imageNamed:@"scan_success_icon"];
  self.statusInfoTitleLabel.text = NSLocalizedString(@"Connected to MyEtherWallet", @"QRScanner. Connection success title");
  self.statusInfoContactSupportButton.hidden = YES;
  {
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentCenter;
    style.lineSpacing = 2.0;
    NSDictionary *attributes = @{NSForegroundColorAttributeName: self.statusInfoDescriptionLabel.textColor,
                                 NSFontAttributeName: self.statusInfoDescriptionLabel.font,
                                 NSParagraphStyleAttributeName: style};
    NSString *text = NSLocalizedString(@"Via encrypted peer-to-peer connection", @"QRScanner. Connection success description");
    self.statusInfoDescriptionLabel.attributedText = [[NSAttributedString alloc] initWithString:text attributes:attributes];
  }
  
  CABasicAnimation *backgroundColorAnimation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
  backgroundColorAnimation.duration = kQRScannerViewControllerFadeAnimationDuration;
  UIColor *color = [UIColor mainApplicationColor];
  backgroundColorAnimation.fromValue = (id)self.view.backgroundColor.CGColor;
  backgroundColorAnimation.toValue = (id)color.CGColor;
  backgroundColorAnimation.removedOnCompletion = YES;
  
  self.view.layer.backgroundColor = color.CGColor;
  [self.view.layer addAnimation:backgroundColorAnimation forKey:@"backgroundColorAnimation"];
  
  ++self.runningAnimations;
  [UIView animateWithDuration:kQRScannerViewControllerFadeAnimationDuration
                   animations:^{
                     self.loadingContainerView.alpha = 0.0;
                     self.statusContainerView.alpha = 1.0;
                   } completion:^(__unused BOOL finished) {
                     --self.runningAnimations;
                     if (self.runningAnimations == 0) {
                       [self.loadingActivity stopAnimating];
                     }
                   }];
}

- (void) hideAccessWarning {
  if (!self.accessToCameraLabel.hidden) {
    self.accessToCameraLabel.alpha = 1.0;
    [UIView animateWithDuration:kQRScannerViewControllerFadeAnimationDuration
                     animations:^{
                       self.accessToCameraLabel.alpha = 0.0;
                     } completion:^(__unused BOOL finished) {
                       self.accessToCameraLabel.hidden = YES;
                     }];
  }
}

- (void) showAccessWarning {
  if (self.accessToCameraLabel.hidden) {
    self.accessToCameraLabel.alpha = 0.0;
    self.accessToCameraLabel.hidden = NO;
    [UIView animateWithDuration:kQRScannerViewControllerFadeAnimationDuration
                     animations:^{
                       self.accessToCameraLabel.alpha = 1.0;
                     } completion:nil];
  }
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

- (IBAction) closeAction:(__unused UIButton *)sender {
  [self.output closeAction];
}

- (IBAction) contactSupport:(__unused UIButton *)sender {
  [self.output contactSupportAction];
}

#pragma mark - Private

- (void) _prepareStepsDescription {
  NSString *step1 = NSLocalizedString(@"Go to MyEtherWallet.com on your computer and choose Send Ether and Tokens option.", @"QRScanner. Step 1");
  NSString *step1Semibolds = NSLocalizedString(@"MyEtherWallet.com|Send Ether|Tokens", @"QRScanner. Step 1. Semibolds");
  NSString *step2 = NSLocalizedString(@"Select MEWconnect option on How would you like to access your wallet screen.", @"QRScanner. Step 2");
  NSString *step2Semibolds = NSLocalizedString(@"MEWconnect|How would you like to access your wallet", @"QRScanner. Step 1. Semibolds");
  NSString *step3 = NSLocalizedString(@"Click Access with MEWconnect and scan the QR code on the screen that will follow. ", @"QRScanner. Step 3");
  NSString *step3Semibolds = NSLocalizedString(@"Access with MEWconnect", @"QRScanner. Step 1. Semibolds");
  
  NSAttributedString *step1AttributedString = [self _prepareString:[step1 stringByAppendingString:@"\n"] stepNumber:1 semiboldParts:[step1Semibolds componentsSeparatedByString:@"|"]];
  NSAttributedString *step2AttributedString = [self _prepareString:[step2 stringByAppendingString:@"\n"] stepNumber:2 semiboldParts:[step2Semibolds componentsSeparatedByString:@"|"]];
  NSAttributedString *step3AttributedString = [self _prepareString:step3 stepNumber:3 semiboldParts:[step3Semibolds componentsSeparatedByString:@"|"]];
  
  NSMutableAttributedString *steps = [[NSMutableAttributedString alloc] init];
  [steps appendAttributedString:step1AttributedString];
  [steps appendAttributedString:step2AttributedString];
  [steps appendAttributedString:step3AttributedString];
  
  self.stepsDescriptionLabel.attributedText = steps;
}

- (NSAttributedString *) _prepareString:(NSString *)string stepNumber:(NSInteger)stepNumber semiboldParts:(NSArray *)semiboldParts {
  if (!string) {
    return [[NSAttributedString alloc] init];
  }
  NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
  style.headIndent = 24.0;
  style.lineSpacing = 2.0;
  style.paragraphSpacing = 20.0;
  
  CGFloat zeroTabOffset = 6.0;
  if ([UIScreen mainScreen].screenSizeType == ScreenSizeTypeInches40) {
    zeroTabOffset = 5.0;
  }
  NSTextTab *zeroTab = [[NSTextTab alloc] initWithTextAlignment:NSTextAlignmentNatural location:zeroTabOffset options:@{}];
  NSTextTab *textTab = [[NSTextTab alloc] initWithTextAlignment:NSTextAlignmentNatural location:24.0 options:@{}];
  style.tabStops = @[zeroTab, textTab];
  CGFloat fontSize = 15.0;
  CGFloat kern = -0.12;
  if ([UIScreen mainScreen].screenSizeType == ScreenSizeTypeInches40) {
    fontSize = 13.0;
    kern = -0.24;
  }
  NSDictionary *attributes = @{NSForegroundColorAttributeName: [UIColor whiteColor],
                               NSFontAttributeName: [UIFont systemFontOfSize:fontSize],
                               NSParagraphStyleAttributeName: style,
                               NSKernAttributeName: @(kern)};
  NSString *finalString = [NSString stringWithFormat:@"\t%zd\t%@", stepNumber, string];
  NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:finalString attributes:attributes];
  //Change text color and font of "1"
  NSRange stringRange = [finalString rangeOfString:string];
  if (stringRange.location != NSNotFound) {
    NSRange stepRange = NSMakeRange(0, stringRange.location);
    NSDictionary *attributes = @{NSForegroundColorAttributeName: [UIColor colorWithRGB:0xabb2ba],
                                 NSFontAttributeName: [UIFont systemFontOfSize:12.0 weight:UIFontWeightSemibold]};
    [attributedString addAttributes:attributes range:stepRange];
  }
  //Change font of semibold parts
  for (NSString *semibold in semiboldParts) {
    NSRange range = [finalString rangeOfString:semibold];
    if (range.location != NSNotFound) {
      [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:fontSize weight:UIFontWeightSemibold] range:range];
    }
  }
  [attributedString fixAttributesInRange:NSMakeRange(0, [attributedString length])];
  return [attributedString copy];
}

- (void) _updatePrefferedContentSize {
  CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
  CGRect bounds = self.presentingViewController.view.window.bounds;
  CGSize size = bounds.size;
  size.height -= CGRectGetHeight(statusBarFrame);
  if (!CGSizeEqualToSize(self.preferredContentSize, size)) {
    self.preferredContentSize = size;
  }
}

#pragma mark - LinkedLabelDelegate

- (void) linkedLabel:(__unused LinkedLabel *)label didSelectURL:(__unused NSURL *)url {
  [self.output settingsAction];
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(__unused MFMailComposeViewController *)controller didFinishWithResult:(__unused MFMailComposeResult)result error:(nullable __unused NSError *)error {
  [self dismissViewControllerAnimated:YES completion:nil];
}

@end
