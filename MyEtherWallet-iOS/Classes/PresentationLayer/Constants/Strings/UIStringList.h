//
//  UIStringList.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 3/19/19.
//  Copyright © 2019 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

@interface UIStringList : NSObject

#pragma mark - Shared
@property (class, strong, readonly) NSString *noInternetConnection;
@property (class, strong, readonly) NSString *cancel;

@end

NS_ASSUME_NONNULL_END
