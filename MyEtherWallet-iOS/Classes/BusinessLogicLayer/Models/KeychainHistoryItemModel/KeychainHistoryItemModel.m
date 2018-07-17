//
//  KeychainHistoryItemModel.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 13/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "KeychainHistoryItemModel.h"

@interface KeychainHistoryItemModel()
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSString *userId;
@end

@implementation KeychainHistoryItemModel

+ (instancetype) historyItemModelWithUserId:(NSString *)userId date:(NSDate *)date {
  KeychainHistoryItemModel *historyItemModel = [[KeychainHistoryItemModel alloc] init];
  historyItemModel.userId = userId;
  historyItemModel.date = date;
  return historyItemModel;
}

@end
