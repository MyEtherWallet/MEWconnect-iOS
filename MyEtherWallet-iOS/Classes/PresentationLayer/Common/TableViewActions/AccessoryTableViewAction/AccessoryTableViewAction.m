//
//  AccessoryTableViewAction.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 24/06/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "AccessoryTableViewAction.h"
#import "CellObjectAction.h"

@implementation AccessoryTableViewAction

- (UITableViewCellAccessoryType)accessoryTypeForObject:(id)object {
  if ([object conformsToProtocol:@protocol(CellObjectAction)]) {
    return [object accessoryType];
  }
  return [super accessoryTypeForObject:object];
}

@end
