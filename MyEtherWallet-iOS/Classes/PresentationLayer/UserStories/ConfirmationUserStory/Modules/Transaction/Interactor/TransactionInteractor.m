//
//  TransactionInteractor.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import libextobjc.EXTScope;

#import "MEWConnectFacade.h"
#import "MEWCrypto.h"

#import "TransactionInteractor.h"

#import "TransactionInteractorOutput.h"

#import "MEWConnectCommand.h"
#import "MEWConnectResponse.h"

@interface TransactionInteractor ()
@property (nonatomic, strong) MEWConnectCommand *message;
@property (nonatomic, strong) MEWConnectTransaction *transaction;
@end

@implementation TransactionInteractor

#pragma mark - TransactionInteractorInput

- (void) configurateWithMessage:(MEWConnectCommand *)message {
  self.message = message;
  self.transaction = [message transaction];
}

- (MEWConnectTransaction *)obtainTransaction {
  return self.transaction;
}

- (void)signTransactionWithPassword:(NSString *)password {
  @weakify(self);
  [self.cryptoService signTransaction:self.transaction
                             password:password
                           completion:^(id data) {
                             @strongify(self);
                             MEWConnectResponse *response = [MEWConnectResponse responseForCommand:self.message data:data];
                             [self.connectFacade sendMessage:response];
                             [self.output transactionDidSigned:response];
                           }];
}

@end
