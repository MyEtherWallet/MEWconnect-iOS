//
//  SimplexQueryTransformer.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 03/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "SimplexQueryTransformer.h"
#import "SimplexQuery.h"
#import "SimplexPaymentQuery.h"

#import "SimplexServiceCurrencyTypes.h"

static NSString *const kSimplexPaymentQueryVersionParameter           = @"version";
static NSString *const kSimplexPaymentQueryPartnerParameter           = @"partner";
static NSString *const kSimplexPaymentQueryPaymentFlowTypeParameter   = @"payment_flow_type";
static NSString *const kSimplexPaymentQueryReturnURLParameter         = @"return_url";
static NSString *const kSimplexPaymentQueryQuoteIDParameter           = @"quote_id";
static NSString *const kSimplexPaymentQueryPaymentIDParameter         = @"payment_id";
static NSString *const kSimplexPaymentQueryUserIDParameter            = @"user_id";
static NSString *const kSimplexPaymentQueryDestinationWalletAddress   = @"destination_wallet[address]";
static NSString *const kSimplexPaymentQueryDestinationWalletCurrency  = @"destination_wallet[currency]";
static NSString *const kSimplexPaymentQueryFiatTotalAmountAmount      = @"fiat_total_amount[amount]";
static NSString *const kSimplexPaymentQueryFiatTotalAmountCurrency    = @"fiat_total_amount[currency]";
static NSString *const kSimplexPaymentQueryDigitalTotalAmountAmount   = @"digital_total_amount[amount]";
static NSString *const kSimplexPaymentQueryDigitalTotalAmountCurrency = @"digital_total_amount[currency]";

static NSString *const kSimplexPaymentQueryPaymentFlowTypeValue       = @"wallet";


@implementation SimplexQueryTransformer

- (NSDictionary *)deriveUrlParametersFromQuery:(id)query {
  if ([query isKindOfClass:[SimplexQuery class]]) {
    return @{};
  } else if ([query isKindOfClass:[SimplexPaymentQuery class]]) {
    SimplexPaymentQuery *paymentQuery = query;
    return @{kSimplexPaymentQueryVersionParameter           : paymentQuery.version,
             kSimplexPaymentQueryPartnerParameter           : paymentQuery.partner,
             kSimplexPaymentQueryPaymentFlowTypeParameter   : kSimplexPaymentQueryPaymentFlowTypeValue,
             kSimplexPaymentQueryReturnURLParameter         : paymentQuery.returnURL,
             kSimplexPaymentQueryQuoteIDParameter           : paymentQuery.quoteID,
             kSimplexPaymentQueryPaymentIDParameter         : paymentQuery.paymentID,
             kSimplexPaymentQueryUserIDParameter            : paymentQuery.userID,
             kSimplexPaymentQueryDestinationWalletAddress   : paymentQuery.destinationWallet,
             kSimplexPaymentQueryDestinationWalletCurrency  : NSStringFromSimplexServiceCurrencyType(SimplexServiceCurrencyTypeETH),
             kSimplexPaymentQueryFiatTotalAmountAmount      : paymentQuery.fiatTotalAmount,
             kSimplexPaymentQueryFiatTotalAmountCurrency    : NSStringFromSimplexServiceCurrencyType(SimplexServiceCurrencyTypeUSD),
             kSimplexPaymentQueryDigitalTotalAmountAmount   : paymentQuery.digitalTotalAmount,
             kSimplexPaymentQueryDigitalTotalAmountCurrency : NSStringFromSimplexServiceCurrencyType(SimplexServiceCurrencyTypeETH),};
  }
  return @{};
}

@end
