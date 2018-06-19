//
//  MEWWalletImplementation.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 29/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "MEWWalletImplementation.h"
#import "MyEtherWallet_iOS-Swift.h"

@implementation MEWWalletImplementation

- (void) createWalletWithPassword:(NSString *)password words:(NSArray<NSString *> *)words completion:(MEWWalletCompletionBlock)completion {
  dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
  dispatch_async(queue, ^{
    NSString *address = [Web3Wrapper createWalletWithPassword:password words:words];
    if (completion) {
      dispatch_async(dispatch_get_main_queue(), ^{
        completion(address != nil, address);
      });
    }
  });
}

- (NSString *) validatePassword:(NSString *)password {
  return [Web3Wrapper validatePasswordWithPassword:password];
}

- (void) signMessage:(NSString *)message password:(NSString *)password completion:(MEWWalletDataCompletionBlock)completion {
  dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
  dispatch_async(queue, ^{
    id signedMessage = [Web3Wrapper signMessage:message password:password];
    if (completion) {
      dispatch_async(dispatch_get_main_queue(), ^{
        completion(signedMessage);
      });
    }
  });
}

- (void) signTransaction:(MEWConnectTransaction *)transaction password:(NSString *)password completion:(MEWWalletDataCompletionBlock)completion {
  dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
  dispatch_async(queue, ^{
    id signedMessage = [Web3Wrapper signTransaction:transaction password:password];
    if (completion) {
      dispatch_async(dispatch_get_main_queue(), ^{
        completion(signedMessage);
      });
    }
  });
}

- (NSString *) obtainPublicAddress {
  return [Web3Wrapper obtainAddress];
}

- (NSArray <NSString *> *) recoveryMnemonicsWords {
  return [Web3Wrapper recoveryMnemonicsWords];
}

- (NSArray <NSString *> *) obtainBIP32Words {
  return [Web3Wrapper bip39Words];
}

- (void)backedUp {
  [Web3Wrapper resetBackup];
}

- (BOOL) isBackedUp {
  return [Web3Wrapper isBackedUp];
}

@end
