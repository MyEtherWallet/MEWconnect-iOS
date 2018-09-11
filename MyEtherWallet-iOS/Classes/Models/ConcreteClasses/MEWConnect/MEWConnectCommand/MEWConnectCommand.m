//
//  MEWConnectCommand.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 03/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "MEWConnectCommand.h"
#import "MEWConnectTransaction.h"
#import "MEWConnectMessage.h"

@implementation MEWConnectCommand

- (MEWConnectTransaction *)transaction {
  if (self.type == MEWConnectCommandTypeSignTransaction) {
    return [MEWConnectTransaction transactionWithJSONString:self.data];
  }
  return nil;
}

- (MEWConnectMessage *)message {
  if (self.type == MEWConnectCommandTypeSignMessage) {
    return [MEWConnectMessage messageWithJSONObject:self.data];
  }
  return nil;
}

@end
