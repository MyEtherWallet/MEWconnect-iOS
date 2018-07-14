//
//  SimplexHeadersBuilder.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 03/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "HeadersBuilderBase.h"

@interface SimplexHeadersBuilder : HeadersBuilderBase
@property (nonatomic, strong) NSDictionary *additionalHeaders;
@end
