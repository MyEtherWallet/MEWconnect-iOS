//
//  AnalyticsServiceImplementation.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 3/10/20.
//  Copyright © 2020 MyEtherWallet, Inc. All rights reserved.
//

@import CoreTelephony;

#import "AnalyticsServiceImplementation.h"

#import "OperationScheduler.h"
#import "CompoundOperationBase.h"

#import "AnalyticsOperationFactory.h"

#import "AnalyticsQuery.h"
#import "AnalyticsBody.h"

@interface AnalyticsServiceImplementation ()
@property (nonatomic, strong) NSString *iso;
@end

@implementation AnalyticsServiceImplementation

- (void) trackBannerShown {
  AnalyticsQuery *query = [self _obtainQuery];
  AnalyticsBody *body = [self _obtainBodyWithEvent:@"iOS-MEWconnectApp-Banner-shown"];
  
  CompoundOperationBase *compoundOperation = [self.analyticsOperationFactory analyticsWithQuery:query body:body];
  [self.operationScheduler addOperation:compoundOperation];
}

- (void) trackBannerClicked {
  AnalyticsQuery *query = [self _obtainQuery];
  AnalyticsBody *body = [self _obtainBodyWithEvent:@"iOS-MEWconnectApp-Banner-FreeUpgrade-clicked"];
  
  CompoundOperationBase *compoundOperation = [self.analyticsOperationFactory analyticsWithQuery:query body:body];
  [self.operationScheduler addOperation:compoundOperation];
}

#pragma mark - Private

- (AnalyticsQuery *) _obtainQuery {
  AnalyticsQuery *query = [[AnalyticsQuery alloc] init];
  query.iso = self.iso;
  return query;
}

- (AnalyticsBody *) _obtainBodyWithEvent:(NSString *)event {
  AnalyticsBody *body = [[AnalyticsBody alloc] init];
  
  NSISO8601DateFormatter *dateFormatter = [[NSISO8601DateFormatter alloc] init];
  dateFormatter.formatOptions = NSISO8601DateFormatWithFullDate | NSISO8601DateFormatWithFullTime;
  if (@available(iOS 11.0, *)) {
    dateFormatter.formatOptions |= NSISO8601DateFormatWithFractionalSeconds;
  }
  
  NSString *timestamp = [dateFormatter stringFromDate:[NSDate date]];
  if (@available(iOS 11.0, *)) {
    //do nothing
  } else {
    if ([timestamp length] > 1) {
      NSMutableString *timestampWithFractionalSeconds = [timestamp mutableCopy];
      [timestampWithFractionalSeconds insertString:@".000" atIndex:[timestamp length] - 1];
      timestamp = [timestampWithFractionalSeconds copy];
    }
  }

  body.events = @[
    @{
      @"id": event,
      @"timestamp": timestamp
    }
  ];
  return body;
}

#pragma mark - Override

- (NSString *)iso {
  if (!_iso) {
    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = networkInfo.subscriberCellularProvider;
    NSString *cellularISO = carrier.isoCountryCode.lowercaseString;
    if ([cellularISO length] > 0) {
      _iso = cellularISO;
      return _iso;
    }
    
    NSString *localeISO = [[NSLocale currentLocale] countryCode].lowercaseString;
    if ([localeISO length] > 0) {
      _iso = localeISO;
      return _iso;
    }
    
    _iso = @"__";
  }
  return _iso;
}

@end
