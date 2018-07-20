//
//  TransactionInteractor.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import libextobjc.EXTScope;

#import "MEWConnectFacade.h"
#import "MEWwallet.h"

#import "TransactionInteractor.h"

#import "TransactionInteractorOutput.h"

#import "AccountPlainObject.h"
#import "NetworkPlainObject.h"
#import "MEWConnectCommand.h"
#import "MEWConnectResponse.h"

@interface TransactionInteractor ()
@property (nonatomic, strong) MEWConnectCommand *message;
@property (nonatomic, strong) MEWConnectTransaction *transaction;
@property (nonatomic, strong) AccountPlainObject *account;
@end

@implementation TransactionInteractor

#pragma mark - TransactionInteractorInput

- (void) configurateWithMessage:(MEWConnectCommand *)message account:(AccountPlainObject *)account {
  self.account = account;
  self.message = message;
  self.transaction = [message transaction];
}

- (AccountPlainObject *)obtainAccount {
  return self.account;
}

- (MEWConnectTransaction *)obtainTransaction {
  return self.transaction;
}

- (void)signTransactionWithPassword:(NSString *)password {
  @weakify(self);
  if (self.transaction) {
    [self.walletService signTransaction:self.transaction
                               password:password
                          publicAddress:self.account.publicAddress
                                network:[self.account.fromNetwork network]
                             completion:^(id data) {
                               @strongify(self);
                               MEWConnectResponse *response = [MEWConnectResponse responseForCommand:self.message data:data];
                               [self.connectFacade sendMessage:response];
                               [self.output transactionDidSigned:response];
                             }];
  }
}

@end
