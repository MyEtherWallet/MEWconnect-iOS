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

#import "QRScannerStatusView.h"

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

@property (nonatomic, weak) IBOutlet UIView *statusBlockView;
@property (nonatomic, weak) IBOutlet UIView *statusContainerView;
@property (nonatomic, weak) QRScannerStatusView *currentStatusView;

@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;

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
}

- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
  [self.output didTriggerViewDidDisappear];
  [self.currentStatusView.activityIndicator stopAnimating];
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
  
  [self _prepareStepsDescription];
  { //title label
    NSDictionary *attributes = @{NSFontAttributeName: self.titleLabel.font,
                                 NSForegroundColorAttributeName: self.titleLabel.textColor,
                                 NSKernAttributeName: @(-0.12)};
    self.titleLabel.attributedText = [[NSAttributedString alloc] initWithString:self.titleLabel.text attributes:attributes];
  }
  {
    self.focusViewTR.layer.transform = CATransform3DMakeScale(-1.0, 1.0, 1.0);
    self.focusViewBL.layer.transform = CATransform3DMakeScale(1.0, -1.0, 1.0);
    self.focusViewBR.layer.transform = CATransform3DMakeScale(-1.0, -1.0, 1.0);
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

- (void) showLoading {
  QRScannerStatusView *statusView = [QRScannerStatusView statusViewWithType:QRScannerStatusViewInProgress];
  [statusView.activityIndicator startAnimating];
  [self _showNewStatusView:statusView withMainColor:[UIColor lightGreyTextColor] secondaryColor:[UIColor connectionLightGrayBackgroundColor]];
}

- (void) showError {
  QRScannerStatusView *statusView = [QRScannerStatusView statusViewWithType:QRScannerStatusViewFailure];
  [statusView.tryAgainButton addTarget:self action:@selector(tryAgainAction:) forControlEvents:UIControlEventTouchUpInside];
  [statusView.contactSupportButton addTarget:self action:@selector(contactSupport:) forControlEvents:UIControlEventTouchUpInside];
  [self _showNewStatusView:statusView withMainColor:[UIColor lightGreyTextColor] secondaryColor:[UIColor connectionLightGrayBackgroundColor]];
}

- (void) showSuccess {
  QRScannerStatusView *statusView = [QRScannerStatusView statusViewWithType:QRScannerStatusViewConnected];
  [self _showNewStatusView:statusView withMainColor:[UIColor mainApplicationColor] secondaryColor:[UIColor mainLightApplicationColor]];
}

- (void) showAccessWarning {
  QRScannerStatusView *statusView = [QRScannerStatusView statusViewWithType:QRScannerStatusViewNoAccess];
  statusView.settingsLinkedLabel.delegate = self;
  [self _showNewStatusView:statusView withMainColor:[UIColor lightGreyTextColor] secondaryColor:[UIColor clearColor]];
}

- (void) showNoConnection {
  QRScannerStatusView *statusView = [QRScannerStatusView statusViewWithType:QRScannerStatusViewNoConnection];
  [self _showNewStatusView:statusView withMainColor:[UIColor lightGreyTextColor] secondaryColor:[UIColor connectionLightGrayBackgroundColor]];
}

- (void) hideStatus {
  [self _hideStatusView];
}

#pragma mark MessageCompose

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

- (IBAction) tryAgainAction:(__unused id)sender {
  [self.output tryAgainAction];
}

#pragma mark - Private

- (void) _showNewStatusView:(QRScannerStatusView *)view withMainColor:(UIColor *)mainColor secondaryColor:(UIColor *)secondaryColor {
  [self.statusContainerView addSubview:view];
  [NSLayoutConstraint activateConstraints:@[[view.centerYAnchor constraintEqualToAnchor:self.statusContainerView.centerYAnchor],
                                            [view.leadingAnchor constraintEqualToAnchor:self.statusContainerView.leadingAnchor],
                                            [view.trailingAnchor constraintEqualToAnchor:self.statusContainerView.trailingAnchor],
                                            [view.topAnchor constraintEqualToAnchor:self.statusContainerView.topAnchor],
                                            [view.bottomAnchor constraintEqualToAnchor:self.statusContainerView.bottomAnchor]]];
  
  [CATransaction begin];
  { //Interior
    CABasicAnimation *backgroundColorAnimation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    backgroundColorAnimation.duration = kQRScannerViewControllerFadeAnimationDuration;
    backgroundColorAnimation.fromValue = (id)self.view.backgroundColor.CGColor;
    backgroundColorAnimation.toValue = (id)mainColor.CGColor;
    backgroundColorAnimation.removedOnCompletion = YES;
    
    self.view.layer.backgroundColor = mainColor.CGColor;
    [self.view.layer addAnimation:backgroundColorAnimation forKey:@"backgroundColorAnimation"];
  }
  { //Connection container
    CABasicAnimation *backgroundColorAnimation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    backgroundColorAnimation.duration = kQRScannerViewControllerFadeAnimationDuration;
    backgroundColorAnimation.fromValue = (id)self.statusBlockView.backgroundColor.CGColor;
    backgroundColorAnimation.toValue = (id)secondaryColor.CGColor;
    backgroundColorAnimation.removedOnCompletion = YES;
    
    self.statusBlockView.layer.backgroundColor = secondaryColor.CGColor;
    [self.statusBlockView.layer addAnimation:backgroundColorAnimation forKey:@"backgroundColorAnimation"];
  }
  [CATransaction commit];
  [UIView animateWithDuration:kQRScannerViewControllerFadeAnimationDuration
                   animations:^{
                     self.statusBlockView.alpha = 1.0;
                     self.closeButton.alpha = view.type == QRScannerStatusViewConnected ? 0.0 : 1.0;
                   }];
  
  [UIView transitionFromView:self.currentStatusView
                      toView:view
                    duration:kQRScannerViewControllerFadeAnimationDuration
                     options:UIViewAnimationOptionTransitionCrossDissolve
                  completion:^(BOOL finished __unused) {
                    self.currentStatusView = view;
                  }];
}

- (void) _hideStatusView {
  [UIView animateWithDuration:kQRScannerViewControllerFadeAnimationDuration
                   animations:^{
                     self.statusBlockView.alpha = 0.0;
                   } completion:^(BOOL finished __unused) {
                     [self.currentStatusView removeFromSuperview];
                   }];
}

- (void) _prepareStepsDescription {
  NSString *step1 = NSLocalizedString(@"Go to MyEtherWallet.com on your computer and choose Access My Wallet option.", @"QRScanner. Step 1");
  NSString *step1Semibolds = NSLocalizedString(@"MyEtherWallet.com|Access My Wallet", @"QRScanner. Step 1. Semibolds");
  NSString *step2 = NSLocalizedString(@"Select MEWconnect option on the screen that follows.", @"QRScanner. Step 2");
  NSString *step2Semibolds = NSLocalizedString(@"MEWconnect", @"QRScanner. Step 1. Semibolds");
  NSString *step3 = NSLocalizedString(@"Scan the QR code.", @"QRScanner. Step 3");
  NSString *step3Semibolds = NSLocalizedString(@"", @"QRScanner. Step 1. Semibolds");
  
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
