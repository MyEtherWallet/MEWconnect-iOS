//
//  AnalyticsOperationFactory.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 3/10/20.
//  Copyright © 2020 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@class CompoundOperationBase;
@class NetworkCompoundOperationBuilder;

@protocol QueryTransformer;
@protocol BodyTransformer;
@protocol HeadersBuilder;

@class AnalyticsQuery;
@class AnalyticsBody;

@interface AnalyticsOperationFactory : NSObject
- (instancetype) initWithBuilder:(NetworkCompoundOperationBuilder *)builder
                queryTransformer:(id<QueryTransformer>)queryTransformer
                 bodyTransformer:(id<BodyTransformer>)bodyTransformer
                  headersBuilder:(id<HeadersBuilder>)headersBuilder;
- (CompoundOperationBase *) analyticsWithQuery:(AnalyticsQuery *)query body:(AnalyticsBody *)body;
@end
