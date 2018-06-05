//
//  MEWCrypto.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 29/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@class MEWConnectTransaction;

typedef void(^MEWCryptoCompletionBlock)(BOOL success, NSString *address);
typedef void(^MEWCryptoDataCompletionBlock)(id data);

@protocol MEWCrypto <NSObject>
- (void) createWalletWithPassword:(NSString *)password words:(NSArray <NSString *> *)words completion:(MEWCryptoCompletionBlock)completion;
- (NSString *) validatePassword:(NSString *)password;
- (void) signMessage:(NSString *)message password:(NSString *)password completion:(MEWCryptoDataCompletionBlock)completion;
- (void) signTransaction:(MEWConnectTransaction *)transaction password:(NSString *)password completion:(MEWCryptoDataCompletionBlock)completion;
- (NSString *) obtainPublicAddress;
- (NSArray <NSString *> *) recoveryMnemonicsWords;
- (NSArray <NSString *> *) obtainBIP32Words;
- (void) backedUp;
- (BOOL) isBackedUp;
@end
