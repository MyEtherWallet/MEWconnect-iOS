//
//  HomeTableViewCellObject.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 22/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "HomeTableViewCellObject.h"
#import "HomeTableViewCell.h"

#import "NSNumberFormatter+USD.h"
#import "NSNumberFormatter+TokenPrice.h"

#import "TokenPlainObject.h"
#import "FiatPricePlainObject.h"

@implementation HomeTableViewCellObject

- (instancetype)initWithToken:(TokenPlainObject *)token {
  if (self) {
    _tokenName = token.name;
    _tokenBalance = token.amountString;
    _token = token;
    
    if (token.price) {
      NSNumberFormatter *usdFormatter = [NSNumberFormatter usdFormatter];
      NSNumberFormatter *tokenUSDFormatter = [NSNumberFormatter tokenUSDFormatter];
      NSDecimalNumber *fiatBalance = [token.amount decimalNumberByMultiplyingBy:token.price.usdPrice];
      _fiatBalance = [usdFormatter stringFromNumber:fiatBalance];
      _tokenPrice = [tokenUSDFormatter stringFromNumber:token.price.usdPrice];
    }
  }
  return self;
}

+ (instancetype)objectWithToken:(TokenPlainObject *)token {
  return [[[self class] alloc] initWithToken:token];
}

#pragma mark - NICellObject

- (Class)cellClass {
  return [HomeTableViewCell class];
}

#pragma mark - NINibCellObject

- (UINib *)cellNib {
  return [UINib nibWithNibName:NSStringFromClass([HomeTableViewCell class]) bundle:[NSBundle mainBundle]];
}

@end
