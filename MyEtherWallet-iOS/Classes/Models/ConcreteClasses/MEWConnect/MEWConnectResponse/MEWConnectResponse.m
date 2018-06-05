//
//  MEWConnectResponse.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 03/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "MEWConnectResponse.h"
#import "MEWConnectCommand.h"

static NSString *const kMEWConnectResponseAddress = @"address";

@implementation MEWConnectResponse

+ (instancetype) responseForCommand:(MEWConnectCommand *)command data:(id)data {
  MEWConnectResponse *response = [[[self class] alloc] init];
  response.type = command.type;
  switch (command.type) {
    case MEWConnectCommandTypeGetAddress: {
      response.data = @{kMEWConnectResponseAddress: data};
      break;
    }
    case MEWConnectCommandTypeSignMessage: {
      response.data = data;
      break;
    }
    case MEWConnectCommandTypeSignTransaction: {
      response.data = data;
      break;
    }
      
    default:
      break;
  }
  return response;
}

@end
