//
//  MEWCryptoImplementation.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 29/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "MEWCryptoImplementation.h"
#import "MyEtherWallet_iOS-Swift.h"

@implementation MEWCryptoImplementation

- (void) createWalletWithPassword:(NSString *)password words:(NSArray<NSString *> *)words completion:(MEWCryptoCompletionBlock)completion {
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

- (void) signMessage:(NSString *)message password:(NSString *)password completion:(MEWCryptoDataCompletionBlock)completion {
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

- (void) signTransaction:(MEWConnectTransaction *)transaction password:(NSString *)password completion:(MEWCryptoDataCompletionBlock)completion {
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

- (nullable NSData *) hashPersonalMessage:(nonnull NSData *)data {
  return nil;
//  var prefix = "\u{19}Ethereum Signed Message:\n"
//  prefix += String(personalMessage.count)
//  guard let prefixData = prefix.data(using: .ascii) else {return nil}
//  var data = Data()
//  if personalMessage.count >= prefixData.count && prefixData == personalMessage[0 ..< prefixData.count] {
//    data.append(personalMessage)
//  } else {
//    data.append(prefixData)
//    data.append(personalMessage)
//  }
//  let hash = data.sha3(.keccak256)
//  return hash
}

@end
