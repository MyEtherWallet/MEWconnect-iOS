//
//  SecurityServiceImplementation.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 07/11/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "SecurityService.h"

@protocol KeychainService;

NS_ASSUME_NONNULL_BEGIN

@interface SecurityServiceImplementation : NSObject <SecurityService>
@property (nonatomic, strong) id <KeychainService> keychainService;
@end

NS_ASSUME_NONNULL_END
