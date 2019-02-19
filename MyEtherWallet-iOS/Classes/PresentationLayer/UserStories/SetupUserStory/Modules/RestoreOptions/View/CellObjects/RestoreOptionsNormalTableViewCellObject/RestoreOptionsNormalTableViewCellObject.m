//
//  RestoreOptionsNormalTableViewCellObject.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 2/18/19.
//  Copyright © 2019 MyEtherWallet, Inc. All rights reserved.
//

#import "RestoreOptionsNormalTableViewCellObject.h"
#import "RestoreOptionsNormalTableViewCell.h"

@implementation RestoreOptionsNormalTableViewCellObject

- (instancetype) initWithType:(RestoreOptionsNormalTableViewCellObjectType)type compact:(BOOL)compact {
  self = [super init];
  if (self) {
    _compact = compact;
    _type = type;
    switch (type) {
      case RestoreOptionsNormalTableViewCellObjectTypeRecoveryPhrase: {
        _title = NSLocalizedString(@"Use recovery phrase", @"RestoreOptions screen");
        break;
      }
      default:
        break;
    }
  }
  return self;
}

+ (instancetype) objectWithType:(RestoreOptionsNormalTableViewCellObjectType)type compact:(BOOL)compact {
  return [[[self class] alloc] initWithType:type compact:(BOOL)compact];
}

#pragma mark - CellObjectAction

- (UITableViewCellAccessoryType) accessoryType {
  return UITableViewCellAccessoryDisclosureIndicator;
}

#pragma mark - NICellObject

- (Class)cellClass {
  return [RestoreOptionsNormalTableViewCell class];
}

#pragma mark - NINibCellObject

- (UINib *)cellNib {
  return [UINib nibWithNibName:NSStringFromClass([RestoreOptionsNormalTableViewCell class]) bundle:[NSBundle mainBundle]];
}

@end
