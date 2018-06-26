//
//  InfoDestructiveTableViewCellObject.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 24/06/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "InfoDestructiveTableViewCellObject.h"
#import "InfoDestructiveTableViewCell.h"

@implementation InfoDestructiveTableViewCellObject

- (instancetype) initWithType:(InfoDestructiveTableViewCellObjectType)type {
  self = [super init];
  if (self) {
    _type = type;
    switch (type) {
      case InfoDestructiveTableViewCellObjectResetType: {
        _title = NSLocalizedString(@"Reset wallet", @"Info screen");
        break;
      }
      default:
        break;
    }
  }
  return self;
}

+ (instancetype) objectWithType:(InfoDestructiveTableViewCellObjectType)type {
  return [[[self class] alloc] initWithType:type];
}

#pragma mark - NICellObject

- (Class)cellClass {
  return [InfoDestructiveTableViewCell class];
}

#pragma mark - NINibCellObject

- (UINib *)cellNib {
  return [UINib nibWithNibName:NSStringFromClass([InfoDestructiveTableViewCell class]) bundle:[NSBundle mainBundle]];
}

@end
