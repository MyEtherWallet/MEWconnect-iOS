//
//  ApplicationConfiguratorImplementation.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 15/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

#import "ApplicationConfigurator.h"

@protocol KeychainService;

@interface ApplicationConfiguratorImplementation : NSObject <ApplicationConfigurator>
@property (nonatomic, strong) id <KeychainService> keychainService;
@end
