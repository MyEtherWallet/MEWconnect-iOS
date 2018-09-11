//
//  MEWWalletImplementation.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 29/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "MEWWalletImplementation.h"
#if BETA
#import "MyEtherWallet_iOS_Beta-Swift.h"
#else
#import "MyEtherWallet_iOS-Swift.h"
#endif

@implementation MEWWalletImplementation

- (void) createWalletWithPassword:(NSString *)password words:(NSArray<NSString *> *)words network:(BlockchainNetworkType)network completion:(MEWWalletCompletionBlock)completion {
  dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
  dispatch_async(queue, ^{
    NSString *address = [self.wrapper createWalletWithPassword:password words:words network:network];
    if (completion) {
      dispatch_async(dispatch_get_main_queue(), ^{
        completion(address != nil, address);
      });
    }
  });
}

- (NSString *) validatePassword:(NSString *)password publicAddress:(NSString *)publicAddress network:(BlockchainNetworkType)network {
  return [self.wrapper validatePasswordWithPassword:password address:publicAddress network:network];
}

- (void) signMessage:(MEWConnectMessage *)message password:(NSString *)password publicAddress:(NSString *)publicAddress network:(BlockchainNetworkType)network completion:(MEWWalletDataCompletionBlock)completion {
  dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
  dispatch_async(queue, ^{
    id signedMessage = [self.wrapper signMessage:message password:password address:publicAddress network:network];
    if (completion) {
      dispatch_async(dispatch_get_main_queue(), ^{
        completion(signedMessage);
      });
    }
  });
}

- (void) signTransaction:(MEWConnectTransaction *)transaction password:(NSString *)password publicAddress:(NSString *)publicAddress network:(BlockchainNetworkType)network completion:(MEWWalletDataCompletionBlock)completion {
  dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
  dispatch_async(queue, ^{
    id signedMessage = [self.wrapper signTransaction:transaction password:password address:publicAddress network:network];
    if (completion) {
      dispatch_async(dispatch_get_main_queue(), ^{
        completion(signedMessage);
      });
    }
  });
}

- (NSArray <NSString *> *) recoveryMnemonicsWordsWithPassword:(NSString *)password publicAddress:(NSString *)publicAddress network:(BlockchainNetworkType)network {
  return [self.wrapper recoveryMnemonicsWords:password address:publicAddress network:network];
}

- (NSArray <NSString *> *) obtainBIP32Words {
  return [self.wrapper bip39Words];
}

@end
