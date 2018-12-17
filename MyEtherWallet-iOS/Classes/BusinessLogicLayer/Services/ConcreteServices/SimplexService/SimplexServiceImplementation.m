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

#import "MasterTokenModelObject.h"
#import "MasterTokenPlainObject.h"

#import "PurchaseHistoryModelObject.h"
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

- (void) quoteWithAmount:(NSDecimalNumber *)amount currency:(SimplexServiceCurrencyType)currency completion:(SimplexServiceQuoteCompletion)completion {
  SimplexQuoteBody *body = [self _obtainQuoteBodyWithAmount:amount currency:currency];

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

- (void) orderForMasterToken:(MasterTokenPlainObject *)masterToken quote:(SimplexQuote *)quote completion:(SimplexServiceOrderCompletion)completion {
  SimplexOrderBody *body = [self _obtainOrderBodyWithQuote:quote forMasterToken:masterToken];
  
  CompoundOperationBase *compoundOperation = [self.simplexOperationFactory orderWithBody:body];
  [compoundOperation setResultBlock:^(SimplexOrder *data, NSError *error) {
    if (data.userID) {
      NSManagedObjectContext *rootSavingContext = [NSManagedObjectContext MR_rootSavingContext];
      [rootSavingContext performBlock:^{
        [self.keychainService savePurchaseUserId:data.userID forMasterToken:masterToken];
        MasterTokenModelObject *masterTokenModelObject = [MasterTokenModelObject MR_findFirstByAttribute:NSStringFromSelector(@selector(address))
                                                                                               withValue:masterToken.address
                                                                                               inContext:rootSavingContext];
        
        PurchaseHistoryModelObject *historyModelObject = [PurchaseHistoryModelObject MR_createEntityInContext:rootSavingContext];
        historyModelObject.date = [NSDate date];
        historyModelObject.userId = data.userID;
        [masterTokenModelObject addPurchaseHistoryObject:historyModelObject];
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
  SimplexStatusQuery *query = [self _obtainStatusQueryWithPurchase:purchase];
  
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

- (NSArray <PurchaseHistoryModelObject *> *) obtainHistoryForMasterToken:(MasterTokenPlainObject *)masterToken {
  NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
  MasterTokenModelObject *masterTokenModelObject = [MasterTokenModelObject MR_findFirstByAttribute:NSStringFromSelector(@selector(address))
                                                                                         withValue:masterToken.address
                                                                                         inContext:context];
  return [masterTokenModelObject.purchaseHistory array];
}

- (void) clearCancelledHistoryForMasterToken:(MasterTokenPlainObject *)masterToken {
  NSManagedObjectContext *context = [NSManagedObjectContext MR_rootSavingContext];
  [context performBlockAndWait:^{
    MasterTokenModelObject *masterTokenModelObject = [MasterTokenModelObject MR_findFirstByAttribute:NSStringFromSelector(@selector(address))
                                                                                           withValue:masterToken.address
                                                                                           inContext:context];
    NSOrderedSet *cancelledPurchases = [masterTokenModelObject.purchaseHistory filteredOrderedSetUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.status == %d", SimplexServicePaymentStatusTypeCancelled]];
    if ([cancelledPurchases count] > 0) {
      [context MR_deleteObjects:cancelledPurchases];
      [context MR_saveToPersistentStoreAndWait];
    }
  }];
}

- (NSURLRequest *) obtainRequestWithOrder:(SimplexOrder *)order forMasterToken:(MasterTokenPlainObject *)masterToken {
  SimplexPaymentQuery *query = [self _obtainPaymentQueryWithOrder:order forMasterToken:masterToken];
  NSURLRequest *request = [self.simplexOperationFactory requestWithQuery:query];
  return request;
}

- (SimplexQuote *)obtainQuote {
  return self.quote;
}

#pragma mark - Private

- (SimplexQuoteBody *) _obtainQuoteBodyWithAmount:(NSDecimalNumber *)amount currency:(SimplexServiceCurrencyType)currency {
  SimplexQuoteBody *body = [[SimplexQuoteBody alloc] init];
  body.digitalCurrency = NSStringFromSimplexServiceCurrencyType(SimplexServiceCurrencyTypeETH);
  body.fiatCurrency = NSStringFromSimplexServiceCurrencyType(SimplexServiceCurrencyTypeUSD);
  body.requestedCurrency = NSStringFromSimplexServiceCurrencyType(currency);
  body.requestedAmount = amount;
  return body;
}

- (SimplexOrderBody *) _obtainOrderBodyWithQuote:(SimplexQuote *)quote forMasterToken:(MasterTokenPlainObject *)masterToken {
  SimplexOrderBody *body = [[SimplexOrderBody alloc] init];
  body.userID = quote.userID;
  body.walletAddress = masterToken.address;
  body.fiatAmount = quote.fiatAmount;
  body.digitalAmount = quote.digitalAmount;
  body.appInstallDate = [self.keychainService obtainFirstLaunchDate];
  return body;
}

- (SimplexPaymentQuery *) _obtainPaymentQueryWithOrder:(SimplexOrder *)order forMasterToken:(MasterTokenPlainObject *)masterToken {
  SimplexPaymentQuery *query = [[SimplexPaymentQuery alloc] init];
  query.postURL = order.postURL;
  query.version = order.apiVersion;
  query.partner = order.partner;
  query.quoteID = order.quoteID;
  query.paymentID = order.paymentID;
  query.userID = order.userID;
  query.returnURL = order.returnURL;
  query.destinationWallet = masterToken.address;
  query.fiatTotalAmount = order.fiatTotalAmount;
  query.digitalTotalAmount = order.digitalTotalAmount;
  return query;
}

- (SimplexStatusQuery *) _obtainStatusQueryWithPurchase:(PurchaseHistoryPlainObject *)history {
  SimplexStatusQuery *query = [[SimplexStatusQuery alloc] init];
  query.userId = history.userId;
  return query;
}

@end
