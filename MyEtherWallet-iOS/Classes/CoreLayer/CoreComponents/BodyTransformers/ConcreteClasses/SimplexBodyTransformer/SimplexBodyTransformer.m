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
static NSString *const kSimplexOrderBodyAppInstallDateParameter         = @"app_install_date";
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
              kSimplexOrderBodyAppEndUserIDParameter            : orderBody.userID,
              kSimplexOrderBodyAppInstallDateParameter          : orderBody.appInstallDate
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
             }
            };
  }
  NSData *jsonData = [NSJSONSerialization dataWithJSONObject:json options:0 error:nil];
  return jsonData;
}

@end
