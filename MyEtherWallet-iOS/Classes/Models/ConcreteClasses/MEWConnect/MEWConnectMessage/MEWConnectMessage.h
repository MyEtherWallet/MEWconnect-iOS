//
//  MEWConnectMessage.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 31/08/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

@interface MEWConnectMessage : NSObject
@property (nonatomic, strong, readonly) NSString *message;
@property (nonatomic, strong, readonly) NSData *messageHash;
+ (instancetype) messageWithJSONObject:(NSDictionary *)data;
@end

NS_ASSUME_NONNULL_END
