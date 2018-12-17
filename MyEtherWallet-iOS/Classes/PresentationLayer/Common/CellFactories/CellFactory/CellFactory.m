//
//  CellFactory.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 23/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "CellFactory.h"

@implementation CellFactory

+ (UITableViewCell *)cellWithNib:(UINib *)cellNib
                       tableView:(UITableView *)tableView
                       indexPath:(NSIndexPath *)indexPath
                          object:(id)object {
  UITableViewCell* cell = nil;
  
  NSString* identifier = NSStringFromClass([object class]);
  [tableView registerNib:cellNib forCellReuseIdentifier:identifier];
  
  cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
  
  // Allow the cell to configure itself with the object's information.
  if ([cell respondsToSelector:@selector(shouldUpdateCellWithObject:)]) {
    [(id<NICell>)cell shouldUpdateCellWithObject:object];
  }
  
  return cell;
}

+ (UITableViewCell *)tableViewModel:(__unused NITableViewModel *)tableViewModel
                   cellForTableView:(UITableView *)tableView
                        atIndexPath:(NSIndexPath *)indexPath
                         withObject:(id)object {
  UITableViewCell* cell = nil;
  
  // Only NICellObject-conformant objects may pass.
  if ([object respondsToSelector:@selector(cellNib)]) {
    UINib* nib = [object cellNib];
    cell = [self cellWithNib:nib tableView:tableView indexPath:indexPath object:object];
  }
  
  return cell;
}

@end
