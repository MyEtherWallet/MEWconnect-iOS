//
//  MEWConnectTransaction.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 04/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@interface MEWConnectTransaction : NSObject
@property (nonatomic, strong, readonly) NSNumber *chainId;
@property (nonatomic, strong, readonly) NSString *data;
@property (nonatomic, strong, readonly) NSString *gas;
@property (nonatomic, strong, readonly) NSString *gasPrice;
@property (nonatomic, strong, readonly) NSString *nonce;
@property (nonatomic, strong, readonly) NSString *to;
@property (nonatomic, strong, readonly) NSString *value;
+ (instancetype) transactionWithJSONString:(NSString *)data;
- (NSDecimalNumber *) decimalValue;
@end
