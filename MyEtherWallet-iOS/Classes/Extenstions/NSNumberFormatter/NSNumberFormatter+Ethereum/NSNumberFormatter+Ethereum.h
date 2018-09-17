//
//  NSNumberFormatter+Ethereum.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 11/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

#import "BlockchainNetworkTypes.h"

@interface NSNumberFormatter (Ethereum)
+ (instancetype)ethereumFormatterWithNetwork:(BlockchainNetworkType)network;
+ (instancetype)ethereumFormatterWithCurrencySymbol:(NSString *)currencySymbol;
@end
