//
//  BuyEtherAmountInteractor.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 02/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import libextobjc.EXTScope;

#import "BuyEtherAmountInteractor.h"

#import "BuyEtherAmountInteractorOutput.h"

#import "SimplexService.h"

#import "AccountPlainObject.h"
#import "NetworkPlainObject.h"
#import "FiatPricePlainObject.h"

#import "SimplexQuote.h"

static short const kBuyEtherAmountRoundingETHScale        = 8;
static short const kBuyEtherAmountRoundingUSDScale        = 2;

static NSDecimalNumber *kBuyEtherMinimumUSDAmount;
static NSDecimalNumber *kBuyEtherMaximumUSDAmount;

@interface BuyEtherAmountInteractor ()
@property (nonatomic, strong) AccountPlainObject *account;
@property (nonatomic) SimplexServiceCurrencyType currency;
@property (nonatomic, strong) NSMutableString *amount;
@end

@implementation BuyEtherAmountInteractor {
  NSDecimalNumberHandler *_ethRoundHandler;
  NSDecimalNumberHandler *_usdRoundHandler;
}

+ (void)initialize {
  kBuyEtherMinimumUSDAmount = [NSDecimalNumber decimalNumberWithString:@"50.0"];
  kBuyEtherMaximumUSDAmount = [NSDecimalNumber decimalNumberWithString:@"20000.0"];
}

#pragma mark - BuyEtherAmountInteractorInput

- (void) configurateWithAccount:(AccountPlainObject *)account {
  _account = account;
  _currency = SimplexServiceCurrencyTypeUSD;
  _amount = [[NSMutableString alloc] initWithString:@"0"];
  _ethRoundHandler = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain
                                                                            scale:kBuyEtherAmountRoundingETHScale
                                                                 raiseOnExactness:NO
                                                                  raiseOnOverflow:NO
                                                                 raiseOnUnderflow:NO
                                                              raiseOnDivideByZero:NO];
  _usdRoundHandler = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain
                                                                            scale:kBuyEtherAmountRoundingUSDScale
                                                                 raiseOnExactness:NO
                                                                  raiseOnOverflow:NO
                                                                 raiseOnUnderflow:NO
                                                              raiseOnDivideByZero:NO];
}

- (void) switchConverting {
  NSDecimalNumber *convertedAmount = [self obtainConvertedAmount];
  NSDecimalNumberHandler *roundHandler = nil;
  switch (_currency) {
    case SimplexServiceCurrencyTypeETH: {
      _currency = SimplexServiceCurrencyTypeUSD;
      roundHandler = _usdRoundHandler;
      break;
    }
    case SimplexServiceCurrencyTypeUSD: {
      _currency = SimplexServiceCurrencyTypeETH;
      roundHandler = _ethRoundHandler;
      break;
    }
  }
  if ([convertedAmount isEqualToNumber:[NSDecimalNumber zero]] || !convertedAmount) {
    [_amount replaceCharactersInRange:NSMakeRange(0, [_amount length]) withString:@"0"];
  } else {
    [_amount replaceCharactersInRange:NSMakeRange(0, [_amount length]) withString:[convertedAmount stringValue]];
  }
}

- (void) appendSymbol:(NSString *)symbol {
  NSString *decimalSeparator = [[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator];
  NSRange separatorRange = [_amount rangeOfString:decimalSeparator];
  NSInteger maxDecimalLength = 0;
  switch (_currency) {
    case SimplexServiceCurrencyTypeUSD: {
      maxDecimalLength = kBuyEtherAmountRoundingUSDScale;
      break;
    }
    case SimplexServiceCurrencyTypeETH: {
      maxDecimalLength = kBuyEtherAmountRoundingETHScale;
      break;
    }
      
    default:
      break;
  }
  if (![symbol isEqualToString:decimalSeparator] || ([symbol isEqualToString:decimalSeparator] && separatorRange.location == NSNotFound)) {
    if (![symbol isEqualToString:decimalSeparator] && [_amount isEqualToString:@"0"]) {
      [_amount replaceCharactersInRange:NSMakeRange(0, [_amount length]) withString:symbol];
    } else if (separatorRange.location == NSNotFound ||
        [_amount length] - separatorRange.location <= maxDecimalLength) {
      [_amount appendString:symbol];
    }
  }
  
  BOOL minimumAmountReached = NO;
  NSDecimalNumber *convertedAmount = [self obtainConvertedAmount];
  switch (_currency) {
    case SimplexServiceCurrencyTypeUSD: {
      NSDecimalNumber *usd = [self _obtainEnteredAmountNumber];
      if ([usd compare:kBuyEtherMaximumUSDAmount] == NSOrderedDescending) {
        usd = kBuyEtherMaximumUSDAmount;
        convertedAmount = [self _obtainConvertedAmountWithCurrency:SimplexServiceCurrencyTypeETH enteredAmount:usd];
        [_amount replaceCharactersInRange:NSMakeRange(0, [_amount length]) withString:[usd stringValue]];
      }
      minimumAmountReached = [usd compare:kBuyEtherMinimumUSDAmount] != NSOrderedAscending;
      break;
    }
    case SimplexServiceCurrencyTypeETH: {
      if (convertedAmount) {
        if ([convertedAmount compare:kBuyEtherMaximumUSDAmount] == NSOrderedDescending) {
          convertedAmount = kBuyEtherMaximumUSDAmount;
          NSDecimalNumber *eth = [self _obtainConvertedAmountWithCurrency:SimplexServiceCurrencyTypeUSD enteredAmount:convertedAmount];
          [_amount replaceCharactersInRange:NSMakeRange(0, [_amount length]) withString:[eth stringValue]];
        }
        minimumAmountReached = [convertedAmount compare:kBuyEtherMinimumUSDAmount] != NSOrderedAscending;
      } else {
        NSDecimalNumber *eth = [self _obtainEnteredAmountNumber];
        minimumAmountReached = [eth compare:[NSDecimalNumber zero]] == NSOrderedDescending;
      }
      break;
    }
      
    default:
      break;
  }
  
  [self.output updateInputPriceWithEnteredAmount:_amount convertedAmount:convertedAmount];
  [self.output minimumAmountDidReached:minimumAmountReached];
}

- (void) eraseSymbol {
  if ([_amount length] > 0) {
    NSRange range = NSMakeRange([_amount length] - 1, 1);
    [_amount replaceCharactersInRange:range withString:@""];
  }

  NSDecimalNumber *convertedAmount = [self obtainConvertedAmount];
  
  BOOL minimumAmountReached = NO;
  switch (_currency) {
    case SimplexServiceCurrencyTypeUSD: {
      NSDecimalNumber *usd = [self _obtainEnteredAmountNumber];
      minimumAmountReached = [usd compare:kBuyEtherMinimumUSDAmount] != NSOrderedAscending;
      break;
    }
    case SimplexServiceCurrencyTypeETH: {
      if (convertedAmount) {
        minimumAmountReached = [convertedAmount compare:kBuyEtherMinimumUSDAmount] != NSOrderedAscending;
      } else {
        NSDecimalNumber *eth = [self _obtainEnteredAmountNumber];
        minimumAmountReached = [eth compare:[NSDecimalNumber zero]] == NSOrderedDescending;
      }
      break;
    }
      
    default:
      break;
  }

  [self.output updateInputPriceWithEnteredAmount:_amount convertedAmount:convertedAmount];
  [self.output minimumAmountDidReached:minimumAmountReached];
}

- (NSString *) obtainEnteredAmount {
  return [_amount copy];
}

- (NSDecimalNumber *) obtainConvertedAmount {
  NSDecimalNumber *enteredAmount = [self _obtainEnteredAmountNumber];
  return [self _obtainConvertedAmountWithCurrency:self.currency enteredAmount:enteredAmount];
}

- (SimplexServiceCurrencyType) obtainCurrencyType {
  return self.currency;
}

- (void) prepareQuote {
  NSDecimalNumber *amount = [self _obtainEnteredAmountNumber];
  if (![amount isEqualToNumber:[NSDecimalNumber zero]]) {
    @weakify(self);
    [self.simplexService quoteForAccount:self.account
                                  amount:amount
                                currency:self.currency
                              completion:^(SimplexQuote *quote, NSError *error) {
                                @strongify(self);
                                if (quote) {
                                  [self.simplexService orderForAccount:self.account
                                                                 quote:quote
                                                            completion:^(SimplexOrder *order, NSError *error) {
                                                              if (error) {
                                                                
                                                              } else {
                                                                [self.output orderDidCreated:order forAccount:self.account];
                                                              }
                                                            }];
                                }
                              }];
  }
}

- (AccountPlainObject *) obtainAccount {
  return self.account;
}

- (NSDecimalNumber *) obtainMinimumAmount {
  return kBuyEtherMinimumUSDAmount;
}

#pragma mark - Private

- (NSDecimalNumber *) _obtainEnteredAmountNumber {
  if ([_amount length] == 0) {
    [_amount appendString:@"0"];
  }
  return [NSDecimalNumber decimalNumberWithString:_amount];
}

- (NSDecimalNumber *) _obtainConvertedAmountWithCurrency:(SimplexServiceCurrencyType)currency enteredAmount:(NSDecimalNumber *)enteredAmount {
  NSDecimalNumber *usdPrice = self.account.price.usdPrice;
  NSDecimalNumber *convertedAmount = nil;
  if (usdPrice) {
    switch (currency) {
      case SimplexServiceCurrencyTypeETH: {
        convertedAmount = [enteredAmount decimalNumberByMultiplyingBy:self.account.price.usdPrice];
        convertedAmount = [convertedAmount decimalNumberByRoundingAccordingToBehavior:_usdRoundHandler];
        break;
      }
      case SimplexServiceCurrencyTypeUSD:
      default: {
        convertedAmount = [enteredAmount decimalNumberByDividingBy:self.account.price.usdPrice];
        convertedAmount = [convertedAmount decimalNumberByRoundingAccordingToBehavior:_ethRoundHandler];
        break;
      }
    }
  }
  return convertedAmount;
}

@end
