//
//  RequestConfigurationType.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 20/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#ifndef RequestConfigurationType_h
#define RequestConfigurationType_h

typedef NS_ENUM(NSUInteger, RequestConfigurationType) {
  RequestConfigurationDisabledType      = 0,
  RequestConfigurationMyEtherAPIType    = 1,
  RequestConfigurationTickerAPIType     = 2,
  RequestConfigurationSimplexAPIType    = 3,
  RequestConfigurationSimplexWebType    = 4,
};

#endif /* RequestConfigurationType_h */
