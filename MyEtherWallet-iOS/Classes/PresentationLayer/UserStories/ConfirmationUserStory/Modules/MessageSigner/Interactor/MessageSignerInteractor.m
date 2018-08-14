//
//  MessageSignerInteractor.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 03/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import libextobjc.EXTScope;

#import "MessageSignerInteractor.h"

#import "MessageSignerInteractorOutput.h"

#import "MEWConnectCommand.h"
#import "MEWConnectResponse.h"

#import "MEWwallet.h"

@interface MessageSignerInteractor ()
@property (nonatomic, strong) MEWConnectCommand *message;
@end

@implementation MessageSignerInteractor

#pragma mark - MessageSignerInteractorInput

- (void) configurateWithMessage:(MEWConnectCommand *)message {
  self.message = message;
}

- (NSString *) obtainMessage {
  return self.message.data;
}

- (void) signMessage {
  @weakify(self);
  //TODO: Sign message
  [self.walletService signMessage:self.message.data
                         password:@""
                    publicAddress:@""
                          network:BlockchainNetworkTypeRopsten
                       completion:^(id data) {
                         @strongify(self);
                         MEWConnectResponse *response = [MEWConnectResponse responseForCommand:self.message data:data];
                         [self.output messageDidSigned:response];
                       }];
}

@end
