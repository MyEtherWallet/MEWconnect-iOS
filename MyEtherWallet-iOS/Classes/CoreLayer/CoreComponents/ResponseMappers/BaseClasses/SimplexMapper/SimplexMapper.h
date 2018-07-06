//
//  SimplexMapper.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 03/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

#import "ResponseMapper.h"

@class SimplexMappingProvider;
@protocol ResponseObjectFormatter;
@protocol EntityNameFormatter;

@interface SimplexMapper : NSObject
@property (nonatomic, strong, readonly) SimplexMappingProvider *provider;
@property (nonatomic, strong, readonly) id<ResponseObjectFormatter> responseFormatter;
- (instancetype)initWithMappingProvider:(SimplexMappingProvider *)mappingProvider
                responseObjectFormatter:(id <ResponseObjectFormatter>)responseFormatter;
@end
