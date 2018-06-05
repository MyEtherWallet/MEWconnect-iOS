//
//  MEWConnectResponseMapper.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 03/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

#import "ResponseMapper.h"

@class MEWMappingProvider;

@interface MEWConnectResponseMapper : NSObject <ResponseMapper>
@property (nonatomic, strong) MEWMappingProvider *provider;

- (instancetype) initWithMappingProvider:(MEWMappingProvider *)mappingProvider;
@end
