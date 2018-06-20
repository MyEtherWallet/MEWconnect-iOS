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
    NSString *address = [self.wrapper createWalletWithPassword:password words:words];
    if (completion) {
      dispatch_async(dispatch_get_main_queue(), ^{
        completion(address != nil, address);
      });
    }
  });
}

- (NSString *) validatePassword:(NSString *)password {
  return [self.wrapper validatePasswordWithPassword:password];
}

- (void) signMessage:(NSString *)message password:(NSString *)password completion:(MEWWalletDataCompletionBlock)completion {
  dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
  dispatch_async(queue, ^{
    id signedMessage = [self.wrapper signMessage:message password:password];
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
    id signedMessage = [self.wrapper signTransaction:transaction password:password];
    if (completion) {
      dispatch_async(dispatch_get_main_queue(), ^{
        completion(signedMessage);
      });
    }
  });
}

- (NSString *) obtainPublicAddress {
  return [self.wrapper obtainAddress];
}

- (NSArray <NSString *> *) recoveryMnemonicsWordsWithPassword:(NSString *)password {
  return [self.wrapper recoveryMnemonicsWords:password];
}

- (NSArray <NSString *> *) obtainBIP32Words {
  return [self.wrapper bip39Words];
}

- (void)backedUp {
  [self.wrapper resetBackup];
}

- (BOOL) isBackedUp {
  return [self.wrapper isBackedUp];
}

@end
