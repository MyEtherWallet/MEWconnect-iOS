//
//  MessageSignerInteractor.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 03/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import libextobjc.EXTScope;

#import "MEWConnectFacade.h"
#import "MEWwallet.h"

#import "MessageSignerInteractor.h"

#import "MessageSignerInteractorOutput.h"

#import "MasterTokenPlainObject.h"
#import "NetworkPlainObject.h"
#import "MEWConnectCommand.h"
#import "MEWConnectResponse.h"

@interface MessageSignerInteractor ()
@property (nonatomic, strong) MEWConnectCommand *command;
@property (nonatomic, strong) MEWConnectMessage *message;
@property (nonatomic, strong) MasterTokenPlainObject *masterToken;
@end

@implementation MessageSignerInteractor

#pragma mark - MessageSignerInteractorInput

- (void) configurateWithMessage:(MEWConnectCommand *)message masterToken:(MasterTokenPlainObject *)masterToken {
  self.command = message;
  self.message = [message message];
  self.masterToken = masterToken;
}

- (AccountPlainObject *) obtainAccount {
  return self.masterToken.fromNetworkMaster.fromAccount;
}

- (MEWConnectMessage *) obtainMessage {
  return self.message;
}

- (void) signMessageWithPassword:(NSString *)password {
  if (self.message) {
    @weakify(self);
    [self.walletService signMessage:self.message
                           password:password
                        masterToken:self.masterToken
                         completion:^(id data) {
                           @strongify(self);
                           if (data) {
                             MEWConnectResponse *response = [MEWConnectResponse responseForCommand:self.command data:data];
                             [self.connectFacade sendMessage:response];
                             [self.output messageDidSigned:response];
                           } else {
                             [self.output messageDidFailure];
                           }
                         }];
  }
}

@end
