//
//  BuyEtherAmountViewController.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 02/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import DZNWebViewController;

#import "BuyEtherAmountViewController.h"

#import "BuyEtherAmountViewOutput.h"

#import "UIColor+Application.h"
#import "UIImage+Color.h"

#import "NSNumberFormatter+USD.h"
#import "NSNumberFormatter+Ethereum.h"

#import "UIScreen+ScreenSizeType.h"

@interface BuyEtherAmountViewController ()
@property (nonatomic, weak) IBOutlet UILabel *amountLabel;
@property (nonatomic, weak) IBOutlet UILabel *amountCurrencyLabel;
@property (nonatomic, weak) IBOutlet UILabel *resultLabel;
@property (nonatomic, weak) IBOutlet UIButton *switchCurrencyButton;
@property (nonatomic, weak) IBOutlet UIButton *separatorButton;
@property (nonatomic, weak) IBOutlet UIButton *buyButton;
@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray <UIButton *> *keypadButtons;
@end

@implementation BuyEtherAmountViewController {
  SimplexServiceCurrencyType _currency;
}

#pragma mark - LifeCycle

- (void) viewDidLoad {
  [super viewDidLoad];
  [self.output didTriggerViewReadyEvent];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
}

- (UIStatusBarStyle) preferredStatusBarStyle {
  return UIStatusBarStyleLightContent;
}

#pragma mark - BuyEtherAmountViewInput

- (void) setupInitialStateWithCurrency:(SimplexServiceCurrencyType)currency minimumAmount:(NSDecimalNumber *)minimumAmount {
  _currency = currency;
  self.amountCurrencyLabel.text = NSStringFromSimplexServiceCurrencyType(currency);
  
  UIImage *switchCurrencyBackgroundImage = [UIImage imageWithColor:[UIColor backgroundLightBlue]
                                                              size:CGSizeMake(36.0, 36.0)
                                                      cornerRadius:10.0];
  [self.switchCurrencyButton setBackgroundImage:switchCurrencyBackgroundImage forState:UIControlStateNormal];
  
  NSString *decimalSeparator = [[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator];
  [self.separatorButton setTitle:decimalSeparator forState:UIControlStateNormal];
  
  NSNumberFormatter *usdFormatter = [NSNumberFormatter usdFormatter];
  usdFormatter.maximumFractionDigits = 0;
  NSString *minimumAmountTitle = [NSString stringWithFormat:NSLocalizedString(@"%@ MINIMUM PURCHASE", @"BuyEther. Minimum amount format"),
                                  [usdFormatter stringFromNumber:minimumAmount]];
  [self.buyButton setTitle:minimumAmountTitle forState:UIControlStateDisabled];
  self.buyButton.enabled = NO;
  
  if ([UIScreen mainScreen].screenSizeType == ScreenSizeTypeInches55) {
    UIFont *font = [UIFont systemFontOfSize:25.0 weight:UIFontWeightRegular];
    for (UIButton *keypadButton in self.keypadButtons) {
      keypadButton.titleLabel.font = font;
    }
  }
}

- (void) updateWithEnteredAmount:(NSString *)enteredAmount convertedAmount:(NSDecimalNumber *)convertedAmount {
  NSString *prefix = nil;
  NSNumberFormatter *convertedFormatter = nil;
  NSString *nullSuffix = nil;
  
  switch (_currency) {
    case SimplexServiceCurrencyTypeUSD: {
      prefix = [NSNumberFormatter usdFormatter].currencySymbol;
      convertedFormatter = [NSNumberFormatter ethereumFormatterWithNetwork:BlockchainNetworkTypeMainnet];
      nullSuffix = convertedFormatter.currencySymbol;
      break;
    }
    case SimplexServiceCurrencyTypeETH: {
      prefix = @"";
      convertedFormatter = [NSNumberFormatter usdFormatter];
      nullSuffix = convertedFormatter.currencyCode;
      break;
    }
      
    default:
      break;
  }
  
  self.amountLabel.text = [prefix stringByAppendingString:enteredAmount];
  if (convertedAmount) {
    self.resultLabel.text = [convertedFormatter stringFromNumber:convertedAmount];
  } else {
    self.resultLabel.text = [@"— " stringByAppendingString:nullSuffix];
  }
}

- (void)updateCurrency:(SimplexServiceCurrencyType)currency {
  _currency = currency;
  self.amountCurrencyLabel.text = NSStringFromSimplexServiceCurrencyType(currency);
}

- (void) enableContinue {  
  self.buyButton.enabled = YES;
}

- (void) disableContinue {
  self.buyButton.enabled = NO;
}

#pragma mark - IBActions

- (IBAction) padButtonAction:(UIButton *)sender {
  NSString *symbol = nil;
  if (sender.tag < 10) {
    symbol = [NSString stringWithFormat:@"%zd", sender.tag];
  } else {
    symbol = [sender titleForState:UIControlStateNormal];
  }
  [self.output didEnterSymbolAction:symbol];
}

- (IBAction) switchConvertingAction:(UIButton *)sender {
  [self.output switchConvertingAction];
}

- (IBAction) padBackspaceAction:(UIButton *)sender {
  [self.output eraseSymbolAction];
}

- (IBAction) closeAction:(id)sender {
  [self.output closeAction];
}

- (IBAction) historyAction:(id)sender {
  [self.output historyAction];
}

- (IBAction) buyAction:(id)sender {
  [self.output buyAction];
}

@end
