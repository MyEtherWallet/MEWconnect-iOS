//
//  ResponseMappingType.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 03/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#ifndef ResponseMappingType_h
#define ResponseMappingType_h

typedef NS_ENUM(NSUInteger, ResponseMappingType) {
  ResponseMappingDisabledType     = 0,
  ResponseMappingMEWConnectType   = 1,
  ResponseMappingCoreDataType     = 2,
  ResponseMappingSimplexType      = 3,
};

#endif /* ResponseMappingType_h */
