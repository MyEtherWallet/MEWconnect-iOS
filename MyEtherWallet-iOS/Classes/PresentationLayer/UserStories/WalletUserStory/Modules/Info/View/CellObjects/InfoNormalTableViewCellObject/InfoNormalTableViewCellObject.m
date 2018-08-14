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

- (instancetype) initWithType:(InfoNormalTableViewCellObjectType)type compact:(BOOL)compact {
  self = [super init];
  if (self) {
    _compact = compact;
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
        _title = NSLocalizedString(@"MyEtherWallet.com", @"Info screen");
        break;
      }
      case InfoNormalTableViewCellObjectTypePrivateAndTerms: {
        _title = NSLocalizedString(@"Privacy and terms", @"Info screen");
        break;
      }
      case InfoNormalTableViewCellObjectTypeUserGuide: {
        _title = NSLocalizedString(@"User guide", @"Info screen");
        break;
      }
      case InfoNormalTableViewCellObjectTypeAbout: {
        _title = NSLocalizedString(@"About", @"Info screen");
      }
      default:
        break;
    }
  }
  return self;
}

+ (instancetype) objectWithType:(InfoNormalTableViewCellObjectType)type compact:(BOOL)compact {
  return [[[self class] alloc] initWithType:type compact:(BOOL)compact];
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
