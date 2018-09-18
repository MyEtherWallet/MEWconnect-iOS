//
//  RateServiceImplementation.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 18/09/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "RateService.h"

@protocol KeychainService;

NS_ASSUME_NONNULL_BEGIN

@interface RateServiceImplementation : NSObject <RateService>
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) id <KeychainService> keychainService;
@end

NS_ASSUME_NONNULL_END
