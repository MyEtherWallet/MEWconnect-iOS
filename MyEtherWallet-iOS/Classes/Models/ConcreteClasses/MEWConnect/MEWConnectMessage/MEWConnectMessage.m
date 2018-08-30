//
//  MEWConnectMessage.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 31/08/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "MEWConnectMessage.h"
#import "NSString+HexData.h"

static NSString *const kMEWconnectMessageText = @"text";
static NSString *const kMEWconnectMessageHash = @"hash";

@implementation MEWConnectMessage

+ (instancetype) messageWithJSONObject:(NSDictionary *)data {
  MEWConnectMessage *message = [[[self class] alloc] init];
  message->_message = data[kMEWconnectMessageText];
  message->_messageHash = [data[kMEWconnectMessageHash] parseHexData];
  return message;
}

@end
