//
//  SimplexBodyTransformer.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 03/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "SimplexBodyTransformer.h"

#import "SimplexQuoteBody.h"
#import "SimplexOrderBody.h"

#import "SimplexServiceCurrencyTypes.h"

static NSString *const kSimplexQuoteBodyDigitalCurrencyParameter        = @"digital_currency";
static NSString *const kSimplexQuoteBodyFiatCurrencyParameter           = @"fiat_currency";
static NSString *const kSimplexQuoteBodyRequestedCurrencyParameter      = @"requested_currency";
static NSString *const kSimplexQuoteBodyRequestedAmountParameter        = @"requested_amount";

static NSString *const kSimplexOrderBodyAccountDetailsParameter         = @"account_details";
static NSString *const kSimplexOrderBodyAppEndUserIDParameter           = @"app_end_user_id";
static NSString *const kSimplexOrderBodyTransactionDetailsParameter     = @"transaction_details";
static NSString *const kSimplexOrderBodyPaymentDetailsParameter         = @"payment_details";
static NSString *const kSimplexOrderBodyFiatTotalAmountParameter        = @"fiat_total_amount";
static NSString *const kSimplexOrderBodyCurrencyParameter               = @"currency";
static NSString *const kSimplexOrderBodyAmountParameter                 = @"amount";
static NSString *const kSimplexOrderBodyRequestedDigitalAmountParameter = @"requested_digital_amount";
static NSString *const kSimplexOrderBodyDestinationWalletParameter      = @"destination_wallet";
static NSString *const kSimplexOrderBodyAddressParameter                = @"address";

@implementation SimplexBodyTransformer

- (NSData *)deriveDataFromBody:(id)body {
  NSDictionary *json = nil;
  if ([body isKindOfClass:[SimplexQuoteBody class]]) {
    SimplexQuoteBody *quoteBody = (SimplexQuoteBody *)body;
    json = @{kSimplexQuoteBodyDigitalCurrencyParameter          : quoteBody.digitalCurrency,
             kSimplexQuoteBodyFiatCurrencyParameter             : quoteBody.fiatCurrency,
             kSimplexQuoteBodyRequestedCurrencyParameter        : quoteBody.requestedCurrency,
             kSimplexQuoteBodyRequestedAmountParameter          : quoteBody.requestedAmount};
  } else {
    SimplexOrderBody *orderBody = (SimplexOrderBody *)body;
    json = @{kSimplexOrderBodyAccountDetailsParameter           : @{
              kSimplexOrderBodyAppEndUserIDParameter            : orderBody.userID
             },
             kSimplexOrderBodyTransactionDetailsParameter       : @{
              kSimplexOrderBodyPaymentDetailsParameter          : @{
               kSimplexOrderBodyFiatTotalAmountParameter        : @{
                kSimplexOrderBodyCurrencyParameter              : NSStringFromSimplexServiceCurrencyType(SimplexServiceCurrencyTypeUSD),
                kSimplexOrderBodyAmountParameter                : orderBody.fiatAmount
               },
               kSimplexOrderBodyRequestedDigitalAmountParameter : @{
                kSimplexOrderBodyCurrencyParameter              : NSStringFromSimplexServiceCurrencyType(SimplexServiceCurrencyTypeETH),
                kSimplexOrderBodyAmountParameter                : orderBody.digitalAmount
               },
               kSimplexOrderBodyDestinationWalletParameter      : @{
                kSimplexOrderBodyCurrencyParameter              : NSStringFromSimplexServiceCurrencyType(SimplexServiceCurrencyTypeETH),
                kSimplexOrderBodyAddressParameter               : orderBody.walletAddress
               }
              }
             },
             @"g-recaptcha-response": @[@"03ACgFB9tiTimXBRHswgHq-td91ayRBwMofhVXT29TV9J8aM05GHFidzvmNWfw3jv1cDc91wROH_0guo_ItatQ950ARP7c28UoKwBXbzH1IZWtWb-zHr-_QF4OH9kYARUK-GCkD1klsYTaHqj_q5UWYJHhoTLqxYqmHQFuvb2aTEqtOdQ5tyigqmIQbLpjMWjB09_ftl7dmXqdBwrwaZ5Qtab0dT_2-fSDMybN8HD4HVcVeyccnFk5CLCAfzzgwdllpJyyScarS-XMvUuAwBrCOhAteHXeYi4w2YYTSyrTamuOQovKF0Eg1ihYPspZbxb1Tzj0u9EpHS53rul36LmGLVT_SHVus7t2ARnW_p7thPrh1UoHSY_iBjpZb9uPHjR5j7SD9YM4jLWJHTloF-uTJjrOO9a8mRo9xhQ4RcRSoDzth5b2f3Xzev6twdCQ4DLyCG_VsKksdFbGULBMpaeMQn4_jZxOtYq5yw"]
            };
  }
  NSData *jsonData = [NSJSONSerialization dataWithJSONObject:json options:0 error:nil];
  return jsonData;
}

@end
