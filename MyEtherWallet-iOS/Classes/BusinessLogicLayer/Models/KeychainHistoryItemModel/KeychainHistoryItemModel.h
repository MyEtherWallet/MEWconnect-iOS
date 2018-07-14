//
//  KeychainHistoryItemModel.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 13/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@interface KeychainHistoryItemModel : NSObject
@property (nonatomic, strong, readonly) NSDate *date;
@property (nonatomic, strong, readonly) NSString *userId;
+ (instancetype) historyItemModelWithUserId:(NSString *)userId date:(NSDate *)date;
@end
