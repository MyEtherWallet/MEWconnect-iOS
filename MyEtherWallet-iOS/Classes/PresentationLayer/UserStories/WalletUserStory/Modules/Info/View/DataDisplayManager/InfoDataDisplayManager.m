//
//  InfoDataDisplayManager.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 24/06/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Nimbus.NimbusModels;
@import libextobjc.EXTScope;

#import "InfoDataDisplayManager.h"

#import "InfoCellObjectBuilder.h"

#import "CellFactory.h"

#import "InfoNormalTableViewCellObject.h"
#import "InfoDestructiveTableViewCellObject.h"

#import "AccessoryTableViewAction.h"

#import "UIScreen+ScreenSizeType.h"

@interface InfoDataDisplayManager ()
@property (nonatomic, strong) NIMutableTableViewModel *tableViewModel;
@property (nonatomic, strong) NITableViewActions *tableViewActions;
@end

@implementation InfoDataDisplayManager

- (void) updateDataDisplayManager {
  [self updateTableViewModel];
  
  BOOL compact = ([UIScreen mainScreen].screenSizeType == ScreenSizeTypeInches40);
  
  [self.tableViewModel addObject:[self.cellObjectBuilder buildEmptyCellObject]];
  [self.tableViewModel addObject:[self.cellObjectBuilder buildContactCellObjectWithCompactSize:compact]];
  [self.tableViewModel addObject:[self.cellObjectBuilder buildUserGuideCellObjectWithCompactSize:compact]];
  [self.tableViewModel addObject:[self.cellObjectBuilder buildKnowledgeBaseCellObjectWithCompactSize:compact]];
  [self.tableViewModel addObject:[self.cellObjectBuilder buildPrivacyAndTermsCellObjectWithCompactSize:compact]];
  [self.tableViewModel addObject:[self.cellObjectBuilder buildMyetherwalletComCellObjectWithCompactSize:compact]];
  [self.tableViewModel addObject:[self.cellObjectBuilder buildAboutCellObjectWithCompactSize:compact]];
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
  [self.tableViewActions attachToClass:[InfoNormalTableViewCellObject class]
                              tapBlock:^BOOL(InfoNormalTableViewCellObject *object, __unused id target, __unused NSIndexPath *indexPath) {
                                @strongify(self);
                                switch (object.type) {
                                  case InfoNormalTableViewCellObjectTypeContact: {
                                    [self.delegate didTapContact];
                                    break;
                                  }
                                  case InfoNormalTableViewCellObjectTypeKnowledgeBase: {
                                    [self.delegate didTapKnowledgeBase];
                                    break;
                                  }
                                  case InfoNormalTableViewCellObjectTypeMyEtherWalletCom: {
                                    [self.delegate didTapMyEtherWalletCom];
                                    break;
                                  }
                                  case InfoNormalTableViewCellObjectTypePrivateAndTerms: {
                                    [self.delegate didTapPrivacyAndTerms];
                                    break;
                                  }
                                  case InfoNormalTableViewCellObjectTypeUserGuide: {
                                    [self.delegate didTapUserGuide];
                                    break;
                                  }
                                  case InfoNormalTableViewCellObjectTypeAbout: {
                                    [self.delegate didTapAbout];
                                    break;
                                  }
                                  default:
                                    break;
                                }
                                return YES;
                              }];
  [self.tableViewActions attachToClass:[InfoDestructiveTableViewCellObject class]
                              tapBlock:^BOOL(__unused InfoDestructiveTableViewCellObject *object, __unused id target, __unused NSIndexPath *indexPath) {
                                @strongify(self);
                                [self.delegate didTapResetWallet];
                                return YES;
                              }];
}

@end
