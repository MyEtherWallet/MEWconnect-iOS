//
//  CrashCatcherConfigurator.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 17/09/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

@protocol CrashCatcherConfigurator <NSObject>
- (void) configurate;
@end

NS_ASSUME_NONNULL_END
