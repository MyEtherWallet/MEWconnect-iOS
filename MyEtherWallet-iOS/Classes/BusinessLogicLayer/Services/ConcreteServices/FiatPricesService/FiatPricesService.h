//
//  FiatPricesService.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 02/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

typedef void(^FiatPricesServiceCompletion)(NSError *error);

@protocol FiatPricesService <NSObject>
- (void) updateFiatPricesWithCompletion:(FiatPricesServiceCompletion)completion;
@end
