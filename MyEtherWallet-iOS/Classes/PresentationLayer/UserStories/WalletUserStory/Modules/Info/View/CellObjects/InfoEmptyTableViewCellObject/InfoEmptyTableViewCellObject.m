//
//  InfoEmptyTableViewCellObject.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 25/06/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "InfoEmptyTableViewCellObject.h"
#import "InfoEmptyTableViewCell.h"

@implementation InfoEmptyTableViewCellObject

+ (instancetype) object {
  return [[[self class] alloc] init];
}

#pragma mark - NICellObject

- (Class)cellClass {
  return [InfoEmptyTableViewCell class];
}

#pragma mark - NINibCellObject

- (UINib *)cellNib {
  return [UINib nibWithNibName:NSStringFromClass([InfoEmptyTableViewCell class]) bundle:[NSBundle mainBundle]];
}

@end
