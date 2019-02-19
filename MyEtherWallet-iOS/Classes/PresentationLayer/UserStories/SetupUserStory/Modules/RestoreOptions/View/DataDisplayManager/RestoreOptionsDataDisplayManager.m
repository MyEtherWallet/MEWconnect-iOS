//
//  RestoreOptionsDataDisplayManager.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 2/18/19.
//  Copyright © 2019 MyEtherWallet, Inc. All rights reserved.
//

@import Nimbus.NimbusModels;
@import libextobjc.EXTScope;

#import "RestoreOptionsDataDisplayManager.h"

#import "RestoreOptionsCellObjectBuilder.h"

#import "CellFactory.h"

#import "RestoreOptionsNormalTableViewCellObject.h"

#import "AccessoryTableViewAction.h"

#import "UIScreen+ScreenSizeType.h"

@interface RestoreOptionsDataDisplayManager ()
@property (nonatomic, strong) NIMutableTableViewModel *tableViewModel;
@property (nonatomic, strong) NITableViewActions *tableViewActions;
@end

@implementation RestoreOptionsDataDisplayManager

- (void) updateDataDisplayManager {
  [self updateTableViewModel];
  
  BOOL compact = ([UIScreen mainScreen].screenSizeType == ScreenSizeTypeInches40);
  
  [self.tableViewModel addObject:[self.cellObjectBuilder buildEmptyCellObject]];
  [self.tableViewModel addObject:[self.cellObjectBuilder buildRecoveryPhraseCellObjectWithCompactSize:compact]];
  [self.tableViewModel addObject:[self.cellObjectBuilder buildEmptyCellObject]];
}

#pragma mark - UITableViewDelegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return [CellFactory tableView:tableView heightForRowAtIndexPath:indexPath model:self.tableViewModel];
}

#pragma mark - DataDisplayManager methods

- (id<UITableViewDataSource>)dataSourceForTableView:(__unused UITableView *)tableView {
  if (!self.tableViewModel) {
    [self updateTableViewModel];
  }
  return self.tableViewModel;
}

- (id<UITableViewDelegate>)delegateForTableView:(__unused UITableView *)tableView withBaseDelegate:(__unused id<UITableViewDelegate>)baseTableViewDelegate {
  if (!self.tableViewActions) {
    [self setupTableViewActions];
  }
  return [self.tableViewActions forwardingTo:self];
}

- (CGFloat)tableView:(__unused UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  if (section == 0) {
    return 19.0;
  } else {
    return 22.0;
  }
}

- (UIView *)tableView:(__unused UITableView *)tableView viewForHeaderInSection:(__unused NSInteger)section {
  return [[UIView alloc] init];
}

#pragma mark - Private

- (void) updateTableViewModel {
  self.tableViewModel = [[NIMutableTableViewModel alloc] initWithDelegate:(id)[CellFactory class]];
  [self.tableViewModel insertSectionWithTitle:@" " atIndex:0];
}

- (void)setupTableViewActions {
  self.tableViewActions = [[AccessoryTableViewAction alloc] initWithTarget:self];
  self.tableViewActions.tableViewCellSelectionStyle = UITableViewCellSelectionStyleDefault;
  
  @weakify(self);
  [self.tableViewActions attachToClass:[RestoreOptionsNormalTableViewCellObject class]
                              tapBlock:^BOOL(RestoreOptionsNormalTableViewCellObject *object, __unused id target, __unused NSIndexPath *indexPath) {
                                @strongify(self);
                                switch (object.type) {
                                  case RestoreOptionsNormalTableViewCellObjectTypeRecoveryPhrase: {
                                    [self.delegate didTapRecoveryPhrase];
                                    break;
                                  }
                                  default:
                                    break;
                                }
                                return YES;
                              }];
}

@end
