//
//  InfoNormalTableViewCellObject.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 24/06/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "InfoNormalTableViewCellObject.h"
#import "InfoNormalTableViewCell.h"

@implementation InfoNormalTableViewCellObject

- (instancetype) initWithType:(InfoNormalTableViewCellObjectType)type {
  self = [super init];
  if (self) {
    _type = type;
    switch (type) {
      case InfoNormalTableViewCellObjectTypeContact: {
        _title = NSLocalizedString(@"Contact", @"Info screen");
        break;
      }
      case InfoNormalTableViewCellObjectTypeKnowledgeBase: {
        _title = NSLocalizedString(@"Knowledge base", @"Info screen");
        break;
      }
      case InfoNormalTableViewCellObjectTypeMyEtherWalletCom: {
        _title = NSLocalizedString(@"Myetherwallet.com", @"Info screen");
        break;
      }
      case InfoNormalTableViewCellObjectTypePrivateAndTerms: {
        _title = NSLocalizedString(@"Privacy and Terms", @"Info screen");
        break;
      }
      default:
        break;
    }
  }
  return self;
}

+ (instancetype) objectWithType:(InfoNormalTableViewCellObjectType)type {
  return [[[self class] alloc] initWithType:type];
}

#pragma mark - CellObjectAction

- (UITableViewCellAccessoryType) accessoryType {
  return UITableViewCellAccessoryDisclosureIndicator;
}

#pragma mark - NICellObject

- (Class)cellClass {
  return [InfoNormalTableViewCell class];
}

#pragma mark - NINibCellObject

- (UINib *)cellNib {
  return [UINib nibWithNibName:NSStringFromClass([InfoNormalTableViewCell class]) bundle:[NSBundle mainBundle]];
}

@end
