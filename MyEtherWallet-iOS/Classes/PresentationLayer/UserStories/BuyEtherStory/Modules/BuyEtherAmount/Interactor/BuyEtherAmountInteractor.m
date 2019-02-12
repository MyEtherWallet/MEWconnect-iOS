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

#import "MasterTokenPlainObject.h"
#import "NetworkPlainObject.h"
#import "FiatPricePlainObject.h"

#import "SimplexQuote.h"

static short const kBuyEtherAmountRoundingETHScale        = 8;
static short const kBuyEtherAmountRoundingUSDScale        = 2;

static NSDecimalNumber *kBuyEtherMinimumUSDAmount;
static NSDecimalNumber *kBuyEtherMaximumUSDAmount;
static NSDecimalNumber *kBuyEtherMidRangeFeeValue;
static NSDecimalNumber *kBuyEtherMidRangeFee;

static NSString *const kBuyEtherAmountDecimalSeparator    = @".";

@interface BuyEtherAmountInteractor ()
@property (nonatomic, strong) MasterTokenPlainObject *masterToken;
@property (nonatomic) SimplexServiceCurrencyType currency;
@property (nonatomic, strong) NSMutableString *amount;
@property (nonatomic, strong) NSDecimalNumber *simplexPrice;
@end

@implementation BuyEtherAmountInteractor {
  NSDecimalNumberHandler *_ethRoundHandler;
  NSDecimalNumberHandler *_usdRoundHandler;
}

+ (void)initialize {
  kBuyEtherMinimumUSDAmount = [NSDecimalNumber decimalNumberWithString:@"50"];
  kBuyEtherMaximumUSDAmount = [NSDecimalNumber decimalNumberWithString:@"20000"];
  kBuyEtherMidRangeFeeValue = [NSDecimalNumber decimalNumberWithString:@"210"];
  kBuyEtherMidRangeFee      = [NSDecimalNumber decimalNumberWithString:@"0.0566"];
}

#pragma mark - BuyEtherAmountInteractorInput

- (void) configurateWithMasterToken:(MasterTokenPlainObject *)masterToken {
  _masterToken = masterToken;
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

- (void) updateEthPriceIfNeeded {
  if (!self.simplexPrice) {
    @weakify(self);
    [self.simplexService quoteWithAmount:[NSDecimalNumber one]
                                currency:SimplexServiceCurrencyTypeETH
                                prequote:YES
                              completion:^(SimplexQuote *quote, __unused NSError *error) {
                                @strongify(self);
                                if (quote) {
                                  self.simplexPrice = quote.fiatBaseAmount;
                                  NSDecimalNumber *convertedAmount = [self obtainConvertedAmount];
                                  
                                  BOOL minimumAmountReached = NO;
                                  switch (self.currency) {
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
                                  
                                  [self.output updateInputPriceWithEnteredAmount:self.amount convertedAmount:convertedAmount];
                                  [self.output minimumAmountDidReached:minimumAmountReached];
                                }
                                [self.output priceDidUpdated];
                              }];
  } else {
    [self.output priceDidUpdated];
  }
}

- (void) switchConverting {
  NSDecimalNumber *convertedAmount = [self obtainConvertedAmount];
  switch (_currency) {
    case SimplexServiceCurrencyTypeETH: {
      _currency = SimplexServiceCurrencyTypeUSD;
      break;
    }
    case SimplexServiceCurrencyTypeUSD: {
      _currency = SimplexServiceCurrencyTypeETH;
      break;
    }
  }
  if ([convertedAmount isEqualToNumber:[NSDecimalNumber zero]] || !convertedAmount) {
    [_amount replaceCharactersInRange:NSMakeRange(0, [_amount length]) withString:@"0"];
  } else {
    [_amount replaceCharactersInRange:NSMakeRange(0, [_amount length]) withString:[convertedAmount stringValue]];
  }
  BOOL minimumAmountReached = NO;
  switch (_currency) {
    case SimplexServiceCurrencyTypeETH: {
      NSDecimalNumber *enteredAmount = [self _obtainEnteredAmountNumber];
      NSDecimalNumber *convertedAmount = [self _obtainConvertedAmountWithCurrency:self.currency enteredAmount:enteredAmount];
      minimumAmountReached = [convertedAmount compare:kBuyEtherMinimumUSDAmount] != NSOrderedAscending;
      break;
    }
    case SimplexServiceCurrencyTypeUSD: {
      NSDecimalNumber *enteredAmount = [self _obtainEnteredAmountNumber];
      minimumAmountReached = [enteredAmount compare:kBuyEtherMinimumUSDAmount] != NSOrderedAscending;
      break;
    }
  }
  [self.output minimumAmountDidReached:minimumAmountReached];
}

- (void) appendSymbol:(NSString *)symbol {
  NSString *decimalSeparator = kBuyEtherAmountDecimalSeparator;
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
        convertedAmount = [self _obtainConvertedAmountWithCurrency:SimplexServiceCurrencyTypeUSD enteredAmount:usd];
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
  [self.output loadingDidStart];
  if (![amount isEqualToNumber:[NSDecimalNumber zero]]) {
    @weakify(self);
    [self.simplexService quoteWithAmount:amount
                                currency:self.currency
                                prequote:NO
                              completion:^(SimplexQuote *quote, __unused NSError *error) {
                                @strongify(self);
                                if (quote) {
                                  [self.simplexService orderForMasterToken:self.masterToken
                                                                 quote:quote
                                                            completion:^(SimplexOrder *order, NSError *error) {
                                                              if (error) {
                                                              } else {
                                                                [self.output orderDidCreated:order forMasterToken:self.masterToken];
                                                              }
                                                              [self.output loadingDidEnd];
                                                            }];
                                } else {
                                  [self.output loadingDidEnd];
                                }
                              }];
  }
}

- (MasterTokenPlainObject *) obtainMasterToken {
  return self.masterToken;
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
  NSDecimalNumber *usdPrice = self.simplexPrice ?: self.masterToken.price.usdPrice;
  NSDecimalNumber *convertedAmount = nil;
  if (usdPrice) {
    switch (currency) {
      case SimplexServiceCurrencyTypeETH: {
        convertedAmount = [enteredAmount decimalNumberByMultiplyingBy:usdPrice];
        convertedAmount = [convertedAmount decimalNumberByAdding:[self _calculateEstimatedFeeForAmount:convertedAmount]];
        convertedAmount = [convertedAmount decimalNumberByRoundingAccordingToBehavior:_usdRoundHandler];
        break;
      }
      case SimplexServiceCurrencyTypeUSD:
      default: {
        convertedAmount = [enteredAmount decimalNumberBySubtracting:[self _calculateEstimatedFeeForAmount:enteredAmount]];
        convertedAmount = [convertedAmount decimalNumberByDividingBy:usdPrice];
        convertedAmount = [convertedAmount decimalNumberByRoundingAccordingToBehavior:_ethRoundHandler];
        break;
      }
    }
  }
  if ([convertedAmount compare:[NSDecimalNumber zero]] == NSOrderedAscending) {
    convertedAmount = [NSDecimalNumber zero];
  }
  return convertedAmount;
}

- (NSDecimalNumber *) _calculateEstimatedFeeForAmount:(NSDecimalNumber *)amount {
  if ([amount compare:[NSDecimalNumber zero]] == NSOrderedSame) {
    return [NSDecimalNumber zero];
  }
  NSDecimalNumber *feePercent = nil;
  NSDecimalNumber *correction = [NSDecimalNumber decimalNumberWithString:@"-0.03"];
  BOOL applyCorrection = NO;
  if ([amount compare:kBuyEtherMidRangeFeeValue] == NSOrderedDescending) {
    feePercent = kBuyEtherMidRangeFee;
  } else {
    applyCorrection = YES;
    NSDecimalNumber *k1 = [NSDecimalNumber decimalNumberWithString:@"10"];
    NSDecimalNumber *k2 = [NSDecimalNumber decimalNumberWithString:@"-0.08"];
    NSDecimalNumber *k3 = [NSDecimalNumber decimalNumberWithString:@"0.01"];
    
    
    NSDecimalNumber *p1 = [k1 decimalNumberByDividingBy:amount];
    NSDecimalNumber *p2 = [k2 decimalNumberByDividingBy:amount];
    
    feePercent = [p1 decimalNumberByAdding:p2];
    feePercent = [feePercent decimalNumberByAdding:k3];
  }
  
  NSDecimalNumber *fee = [amount decimalNumberByMultiplyingBy:feePercent];
  if (applyCorrection) {
    fee = [fee decimalNumberByAdding:correction];
  }
  return fee;
}

@end
