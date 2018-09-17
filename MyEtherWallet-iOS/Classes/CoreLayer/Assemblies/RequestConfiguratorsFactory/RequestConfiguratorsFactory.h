//
//  RequestConfiguratorsFactory.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 21/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

#import "RequestConfigurationType.h"

@protocol RequestConfigurator;

@protocol RequestConfiguratorsFactory <NSObject>
- (id<RequestConfigurator>) requestConfiguratorWithType:(NSNumber *)type;
- (id<RequestConfigurator>) requestConfiguratorWithType:(NSNumber *)type url:(NSURL *)url;
@end
