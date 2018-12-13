//
//  MEWconnectTokenTransfer.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 13/12/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

@interface MEWconnectTokenTransfer : NSObject
@property (nonatomic, strong, readonly) NSString *to;
@property (nonatomic, strong, readonly) NSDecimalNumber *decimalValue;
+ (instancetype) tokenTransferWithData:(id)data;
@end

NS_ASSUME_NONNULL_END
