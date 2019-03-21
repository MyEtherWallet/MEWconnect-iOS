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
#import "Ponsomizer.h"
#import "TokensService.h"

#import "TransactionInteractor.h"

#import "TransactionInteractorOutput.h"

#import "MasterTokenPlainObject.h"
#import "NetworkPlainObject.h"
#import "MEWConnectCommand.h"
#import "MEWConnectResponse.h"
#import "MEWConnectTransaction.h"


@interface TransactionInteractor ()
@property (nonatomic, strong) MEWConnectCommand *message;
@property (nonatomic, strong) MEWConnectTransaction *transaction;
@property (nonatomic, strong) MasterTokenPlainObject *masterToken;
@end

@implementation TransactionInteractor

#pragma mark - TransactionInteractorInput

- (void) configurateWithMessage:(MEWConnectCommand *)message masterToken:(MasterTokenPlainObject *)masterToken {
  self.masterToken = masterToken;
  self.message = message;
  self.transaction = [message transaction];
  if ([self.transaction isTransfer]) {
    NSString *tokenAddress = self.transaction.token.address ?: self.transaction.to;
    TokenModelObject *tokenModelObject = [self.tokensService obtainTokenWithAddress:tokenAddress
                                                                      ofMasterToken:masterToken];
    if (tokenModelObject) {
      NSArray <NSString *> *ignoringProperties = @[NSStringFromSelector(@selector(fromNetwork)),
                                                   NSStringFromSelector(@selector(purchaseHistory))];
      self.transaction.token = [self.ponsomizer convertObject:tokenModelObject ignoringProperties:ignoringProperties];
    }
  } else {
    self.transaction.token = self.masterToken;
  }
}

- (AccountPlainObject *)obtainAccount {
  return self.masterToken.fromNetworkMaster.fromAccount;
}

- (MEWConnectTransaction *)obtainTransaction {
  return self.transaction;
}

- (NSString *) obtainNetworkToConfirm {
  BlockchainNetworkType transactionNetwork = [self.transaction.chainId integerValue];
  BlockchainNetworkType accountNetwork = [self.masterToken.fromNetworkMaster network];
  if (transactionNetwork != accountNetwork) {
    return [BlockchainNetworkTypesInfoProvider nameForNetworkType:transactionNetwork];
  }
  return nil;
}

- (void)signTransactionWithPassword:(NSString *)password {
  if (self.transaction) {
    @weakify(self);
    [self.walletService signTransaction:self.transaction
                               password:password
                            masterToken:self.masterToken
                             completion:^(id data) {
                               @strongify(self);
                               MEWConnectResponse *response = [MEWConnectResponse responseForCommand:self.message data:data];
                               [self.connectFacade sendMessage:response];
                               [self.output transactionDidSigned:response];
                             }];
  }
}

@end
