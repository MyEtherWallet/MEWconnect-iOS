//
//  NewWalletViewController.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "NewWalletViewController.h"

#import "NewWalletViewOutput.h"

#import "TypingAnimationLabel.h"

#import "UIColor+Application.h"
#import "UIColor+Hex.h"
#import "UIScreen+ScreenSizeType.h"

@interface NewWalletViewController () <TypingAnimationLabelDelegate>
@property (nonatomic, weak) IBOutlet TypingAnimationLabel *typingLabel;
@property (nonatomic, weak) IBOutlet UIButton *startUsingButton;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *helperViewHeightConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *startUsingCenterYConstraint;
@end

@implementation NewWalletViewController {
  NSArray *_texts;
}

#pragma mark - LifeCycle

- (void)viewDidLoad {
	[super viewDidLoad];

	[self.output didTriggerViewReadyEvent];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  self.navigationItem.hidesBackButton = YES;
  [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  [self.typingLabel animateTextArray:_texts];
}

#pragma mark - NewWalletViewInput

- (void) setupInitialState {
  if ([UIScreen mainScreen].screenSizeType == ScreenSizeTypeInches40) {
    self.helperViewHeightConstraint.constant = 201.0;
    self.startUsingCenterYConstraint.constant = -24.0;
  }
  NSMutableArray *texts = [[NSMutableArray alloc] init];
  { //Prepare texts
    { //Generating your Ethereum address
      NSString *text = NSLocalizedString(@"Generating your Ethereum address\n", @"New wallet animation. Step 1");
      NSString *focus = NSLocalizedString(@"Ethereum address", @"New wallet animation. Step 1. Focus");
      NSAttributedString *attributedText = [self _generateAttributedTextFromString:text focus:focus fontSize:34.0 paragraphSpacing:7.0];
      [texts addObject:attributedText];
    }
    { //Encrypting your private key using your password
      NSString *text = NSLocalizedString(@"Encrypting your private key using your password\n", @"New wallet animation. Step 2");
      NSString *focus = NSLocalizedString(@"private key", @"New wallet animation. Step 2. Focus");
      NSAttributedString *attributedText = [self _generateAttributedTextFromString:text focus:focus fontSize:34.0 paragraphSpacing:7.0];
      [texts addObject:attributedText];
    }
    { //Saving your encrypted keys to a local secure vault on this device▋
      NSString *text = NSLocalizedString(@"Saving your encrypted keys to a local secure vault on this device\n", @"New wallet animation. Step 3");
      NSString *focus = NSLocalizedString(@"local secure vault", @"New wallet animation. Step 3. Focus");
      NSAttributedString *attributedText = [self _generateAttributedTextFromString:text focus:focus fontSize:34.0 paragraphSpacing:11.0];
      [texts addObject:attributedText];
    }
    { //All done!
      NSString *text = NSLocalizedString(@"All done!", @"New wallet animation. Step 4");
      NSString *focus = NSLocalizedString(@"All done!", @"New wallet animation. Step 4. Focus");
      NSAttributedString *attributedText = [self _generateAttributedTextFromString:text focus:focus fontSize:38.0 paragraphSpacing:0.0];
      [texts addObject:attributedText];
    }
  }
  { //Caret
    UIFont *font = [UIFont fontWithName:@"PingFangSC-Semibold" size:34.0];
    NSDictionary *attributes = @{NSFontAttributeName: font,
                                 NSForegroundColorAttributeName: [UIColor mainApplicationColor]};
    NSMutableAttributedString *caretAttributedString = [[NSMutableAttributedString alloc] initWithString:@"▋" attributes:attributes];
    [self.typingLabel updateCaretAttributedString:caretAttributedString];
  }
  _texts = texts;
}

#pragma mark - IBActions

- (IBAction) startUsingAction:(__unused id)sender {
  [self.output startUsingAction];
}

#pragma mark - Private

- (NSAttributedString *) _generateAttributedTextFromString:(NSString *)string focus:(NSString *)focus fontSize:(CGFloat)fontSize paragraphSpacing:(CGFloat)paragraphSpacing {
  NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
  style.paragraphSpacing = paragraphSpacing;
  NSDictionary *attributes = @{NSForegroundColorAttributeName: [UIColor blackColor],
                               NSFontAttributeName: [UIFont systemFontOfSize:fontSize weight:UIFontWeightBold],
                               NSKernAttributeName: @(-0.4)};
  NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string
                                                                                       attributes:attributes];
  NSRange range = [string rangeOfString:focus];
  if (range.location != NSNotFound) {
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor mainApplicationColor] range:range];
    if ([UIScreen mainScreen].screenSizeType != ScreenSizeTypeInches40) {
      [attributedString.mutableString replaceOccurrencesOfString:@" "
                                                      withString:@"\u00a0" //Non-breaking space
                                                         options:0
                                                           range:range];
    }
  }
  {
    [attributedString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, [attributedString length])];
  }
  return [attributedString copy];
}

#pragma mark - TypingAnimationLabelDelegate

- (void)typingAnimationLabel:(TypingAnimationLabel *)label performCustomAnimationWithCompletionHandler:(TypingAnimationLabelCompletionHandler)completion {
  NSMutableAttributedString *attributedString = [label.attributedText mutableCopy];
  [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRGB:0x9B9B9B alpha:0.29] range:NSMakeRange(0, [attributedString length])];
  [attributedString fixAttributesInRange:NSMakeRange(0, [attributedString length])];
  [UIView transitionWithView:label
                    duration:1.0
                     options:UIViewAnimationOptionTransitionCrossDissolve
                  animations:^{
                    label.attributedText = attributedString;
                  } completion:^(__unused BOOL finished) {
                    completion(attributedString);
                  }];
}

- (void)typingAnimationLabelDidFinishAnimation:(__unused TypingAnimationLabel *)label {
  [UIView animateWithDuration:0.3
                   animations:^{
                     self.startUsingButton.alpha = 1.0;
                   }];
}

@end
