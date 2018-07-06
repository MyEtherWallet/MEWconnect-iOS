//
//  BuyEtherHistoryEmptyTableViewCellObject.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 06/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "BuyEtherHistoryEmptyTableViewCellObject.h"
#import "BuyEtherHistoryEmptyTableViewCell.h"

@implementation BuyEtherHistoryEmptyTableViewCellObject

- (instancetype) init {
  self = [super init];
  if (self) {
    self.title = NSLocalizedString(@"Your credit card purchases\nwill be displayed here", @"Buy Ether. History. Empty cell text");
  }
  return self;
}

+ (instancetype)object {
  return [[[self class] alloc] init];
}

#pragma mark - NICellObject

- (Class)cellClass {
  return [BuyEtherHistoryEmptyTableViewCell class];
}

#pragma mark - NINibCellObject

- (UINib *)cellNib {
  return [UINib nibWithNibName:NSStringFromClass([BuyEtherHistoryEmptyTableViewCell class]) bundle:[NSBundle mainBundle]];
}

@end
