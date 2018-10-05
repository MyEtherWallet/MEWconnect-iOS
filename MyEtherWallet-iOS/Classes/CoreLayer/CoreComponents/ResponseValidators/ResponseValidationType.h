//
//  ResponseValidationType.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 21/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#ifndef ResponseValidationType_h
#define ResponseValidationType_h

typedef NS_ENUM(NSUInteger, ResponseValidationType) {
  ResponseValidationDisabledType    = 0,
  ResponseValidationSingleType      = 1,
  ResponseValidationManyType        = 2,
  ResponseValidationFiatPricesType  = 3,
  ResponseValidationSimplexType     = 4,
  ResponseValidationEthereumType    = 5,
  ResponseValidationTokensType      = 6,
};

#endif /* ResponseValidationType_h */
