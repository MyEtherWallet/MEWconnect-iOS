//
//  SimplexServiceImplementation.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 03/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import MagicalRecord;
@import libextobjc.EXTScope;

#import "SimplexServiceImplementation.h"

#import "KeychainService.h"

#import "OperationScheduler.h"
#import "CompoundOperationBase.h"

#import "SimplexOperationFactory.h"

#import "SimplexServiceStatusTypes.h"

#import "AccountModelObject.h"
#import "PurchaseHistoryModelObject.h"
#import "AccountPlainObject.h"
#import "NetworkPlainObject.h"
#import "PurchaseHistoryPlainObject.h"

#import "SimplexQuoteBody.h"
#import "SimplexOrderBody.h"

#import "SimplexPaymentQuery.h"
#import "SimplexStatusQuery.h"

#import "SimplexQuote.h"
#import "SimplexOrder.h"

@interface SimplexServiceImplementation ()
@property (nonatomic, strong) SimplexQuote *quote;
@end

@implementation SimplexServiceImplementation

- (void) quoteForAccount:(AccountPlainObject *)account amount:(NSDecimalNumber *)amount currency:(SimplexServiceCurrencyType)currency completion:(SimplexServiceQuoteCompletion)completion {

  SimplexQuoteBody *body = [self obtainQuoteBodyWithAmount:amount currency:currency];

  CompoundOperationBase *compoundOperation = [self.simplexOperationFactory quoteWithBody:body];
  [compoundOperation setResultBlock:^(SimplexQuote *data, NSError *error) {
    self.quote = data;
    dispatch_async(dispatch_get_main_queue(), ^{
      if (completion) {
        completion(data, error);
      }
    });
  }];
  [self.operationScheduler cancelAllOperations];
  [self.operationScheduler addOperation:compoundOperation];
}

- (void) orderForAccount:(AccountPlainObject *)account quote:(SimplexQuote *)quote completion:(SimplexServiceOrderCompletion)completion {
  SimplexOrderBody *body = [self obtainOrderBodyWithQuote:quote forAccount:account];
  
  CompoundOperationBase *compoundOperation = [self.simplexOperationFactory orderWithBody:body];
  [compoundOperation setResultBlock:^(SimplexOrder *data, NSError *error) {
    if (data.userID) {
      NSManagedObjectContext *rootSavingContext = [NSManagedObjectContext MR_rootSavingContext];
      [rootSavingContext performBlock:^{
        [self.keychainService saveSimplexUserId:data.userID ofPublicAddress:account.publicAddress fromNetwork:[account.fromNetwork network]];
        AccountModelObject *accountModelObject = [AccountModelObject MR_findFirstByAttribute:NSStringFromSelector(@selector(publicAddress))
                                                                                   withValue:account.publicAddress
                                                                                   inContext:rootSavingContext];
        PurchaseHistoryModelObject *historyModelObject = [PurchaseHistoryModelObject MR_createEntityInContext:rootSavingContext];
        historyModelObject.date = [NSDate date];
        historyModelObject.userId = data.userID;
        [accountModelObject addPurchaseHistoryObject:historyModelObject];
        [rootSavingContext MR_saveToPersistentStoreAndWait];
      }];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
      if (completion) {
        completion(data, error);
      }
    });
  }];
  [self.operationScheduler addOperation:compoundOperation];
}

- (void) statusForPurchase:(PurchaseHistoryPlainObject *)purchase completion:(SimplexServiceStatusCompletion)completion {
  SimplexStatusQuery *query = [self obtainStatusQueryWithPurchase:purchase];
  
  NSManagedObjectContext *rootSavingContext = [NSManagedObjectContext MR_rootSavingContext];
  [rootSavingContext performBlock:^{
    CompoundOperationBase *compoundOperation = [self.simplexOperationFactory statusWithQuery:query];
    [compoundOperation setResultBlock:^(NSArray <PurchaseHistoryModelObject *> *data, NSError *error) {
      for (PurchaseHistoryModelObject *historyItem in data) {
        if ([historyItem.status shortValue] != SimplexServicePaymentStatusTypeUnknown) {
          historyItem.loaded = @YES;
        }
      }
      if ([rootSavingContext hasChanges]) {
        [rootSavingContext MR_saveToPersistentStoreAndWait];
      }
      
      dispatch_async(dispatch_get_main_queue(), ^{
        if (completion) {
          completion(error);
        }
      });
    }];
    [self.operationScheduler addOperation:compoundOperation];
  }];
}

- (NSArray <PurchaseHistoryModelObject *> *) obtainHistoryForAccount:(AccountPlainObject *)account {
  NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
  AccountModelObject *accountModelObject = [AccountModelObject MR_findFirstByAttribute:NSStringFromSelector(@selector(publicAddress)) withValue:account.publicAddress inContext:context];
  return [accountModelObject.purchaseHistory array];
}

- (NSURLRequest *) obtainRequestWithOrder:(SimplexOrder *)order forAccount:(AccountPlainObject *)account {
  SimplexPaymentQuery *query = [self obtainPaymentQueryWithOrder:order account:account];
  NSURLRequest *request = [self.simplexOperationFactory requestWithQuery:query];
  return request;
}

- (SimplexQuote *)obtainQuote {
  return self.quote;
}

#pragma mark - Private

- (SimplexQuoteBody *) obtainQuoteBodyWithAmount:(NSDecimalNumber *)amount currency:(SimplexServiceCurrencyType)currency {
  SimplexQuoteBody *body = [[SimplexQuoteBody alloc] init];
  body.digitalCurrency = NSStringFromSimplexServiceCurrencyType(SimplexServiceCurrencyTypeETH);
  body.fiatCurrency = NSStringFromSimplexServiceCurrencyType(SimplexServiceCurrencyTypeUSD);
  body.requestedCurrency = NSStringFromSimplexServiceCurrencyType(currency);
  body.requestedAmount = amount;
  return body;
}

- (SimplexOrderBody *) obtainOrderBodyWithQuote:(SimplexQuote *)quote forAccount:(AccountPlainObject *)account {
  SimplexOrderBody *body = [[SimplexOrderBody alloc] init];
  body.userID = quote.userID;
  body.walletAddress = account.publicAddress;
  body.fiatAmount = quote.fiatAmount;
  body.digitalAmount = quote.digitalAmount;
  body.appInstallDate = [self.keychainService obtainFirstLaunchDate];
  return body;
}

- (SimplexPaymentQuery *) obtainPaymentQueryWithOrder:(SimplexOrder *)order account:(AccountPlainObject *)account {
  SimplexPaymentQuery *query = [[SimplexPaymentQuery alloc] init];
  query.postURL = order.postURL;
  query.version = order.apiVersion;
  query.partner = order.partner;
  query.quoteID = order.quoteID;
  query.paymentID = order.paymentID;
  query.userID = order.userID;
  query.returnURL = order.returnURL;
  query.destinationWallet = account.publicAddress;
  query.fiatTotalAmount = order.fiatTotalAmount;
  query.digitalTotalAmount = order.digitalTotalAmount;
  return query;
}

- (SimplexStatusQuery *) obtainStatusQueryWithPurchase:(PurchaseHistoryPlainObject *)history {
  SimplexStatusQuery *query = [[SimplexStatusQuery alloc] init];
  query.userId = history.userId;
  return query;
}

@end
