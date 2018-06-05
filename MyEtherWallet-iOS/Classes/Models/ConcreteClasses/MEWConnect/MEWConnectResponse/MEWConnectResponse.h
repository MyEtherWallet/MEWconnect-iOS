//
//  MEWConnectResponse.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 03/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@class MEWConnectCommand;

#import "MEWConnectCommandTypes.h"

@interface MEWConnectResponse : NSObject
@property (nonatomic) MEWConnectCommandType type;
@property (nonatomic, strong) id data;
+ (instancetype) responseForCommand:(MEWConnectCommand *)command data:(id)data;
@end
