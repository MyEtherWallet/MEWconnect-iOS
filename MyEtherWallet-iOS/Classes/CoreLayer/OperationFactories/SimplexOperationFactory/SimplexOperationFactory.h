//
//  SimplexOperationFactory.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 03/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@class CompoundOperationBase;
@class NetworkCompoundOperationBuilder;

@protocol RequestConfiguratorsFactory;

@protocol QueryTransformer;
@protocol BodyTransformer;
@protocol HeadersBuilder;

@class SimplexPaymentQuery;
@class SimplexStatusQuery;

@class SimplexQuoteBody;
@class SimplexOrderBody;

@interface SimplexOperationFactory : NSObject
@property (nonatomic, strong) id<RequestConfiguratorsFactory> requestConfiguratorsFactory;
- (instancetype) initWithBuilder:(NetworkCompoundOperationBuilder *)builder
                queryTransformer:(id<QueryTransformer>)queryTransformer
                 bodyTransformer:(id<BodyTransformer>)bodyTransformer
                  headersBuilder:(id<HeadersBuilder>)headersBuilder;
- (CompoundOperationBase *) quoteWithBody:(SimplexQuoteBody *)body;
- (CompoundOperationBase *) orderWithBody:(SimplexOrderBody *)body;
- (CompoundOperationBase *) statusWithQuery:(SimplexStatusQuery *)query;
- (NSURLRequest *) requestWithQuery:(SimplexPaymentQuery *)query;
@end
