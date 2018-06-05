//
//  ResponseMappersFactory.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 03/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

#import "ResponseMappingType.h"

@protocol ResponseMapper;

@protocol ResponseMappersFactory <NSObject>
- (id<ResponseMapper>)mapperWithType:(NSNumber *)type;
@end
