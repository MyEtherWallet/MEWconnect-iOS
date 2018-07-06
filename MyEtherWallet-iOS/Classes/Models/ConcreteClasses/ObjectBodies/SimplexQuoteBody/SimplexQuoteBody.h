//
//  SimplexQuoteBody.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 03/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@interface SimplexQuoteBody : NSObject
@property (nonatomic, strong) NSString *digitalCurrency;
@property (nonatomic, strong) NSString *fiatCurrency;
@property (nonatomic, strong) NSString *requestedCurrency;
@property (nonatomic, strong) NSDecimalNumber *requestedAmount;
@end
