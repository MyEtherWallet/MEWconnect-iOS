//
//  MEWWallet.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 29/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@class MEWConnectTransaction;

typedef void(^MEWWalletCompletionBlock)(BOOL success, NSString *address);
typedef void(^MEWWalletDataCompletionBlock)(id data);

@protocol MEWWallet <NSObject>
- (void) createWalletWithPassword:(NSString *)password words:(NSArray <NSString *> *)words completion:(MEWWalletCompletionBlock)completion;
- (NSString *) validatePassword:(NSString *)password;
- (void) signMessage:(NSString *)message password:(NSString *)password completion:(MEWWalletDataCompletionBlock)completion;
- (void) signTransaction:(MEWConnectTransaction *)transaction password:(NSString *)password completion:(MEWWalletDataCompletionBlock)completion;
- (NSString *) obtainPublicAddress;
- (NSArray <NSString *> *) recoveryMnemonicsWordsWithPassword:(NSString *)password;
- (NSArray <NSString *> *) obtainBIP32Words;
- (void) backedUp;
- (BOOL) isBackedUp;
@end
