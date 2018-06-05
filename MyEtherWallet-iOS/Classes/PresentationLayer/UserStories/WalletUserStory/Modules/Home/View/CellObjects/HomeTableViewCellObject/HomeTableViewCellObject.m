//
//  HomeTableViewCellObject.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 22/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "HomeTableViewCellObject.h"
#import "HomeTableViewCell.h"

#import "TokenPlainObject.h"

@implementation HomeTableViewCellObject

- (instancetype)initWithToken:(TokenPlainObject *)token {
  if (self) {
    _tokenName = token.name;
    _tokenBalance = token.amountString;
    _token = token;
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
