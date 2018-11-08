//
//  MEWwallet.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 29/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

#import "BlockchainNetworkTypes.h"

@class AccountPlainObject;
@class NetworkPlainObject;
@class MasterTokenPlainObject;

@class MEWConnectTransaction;
@class MEWConnectMessage;

typedef void(^MEWwalletCreateCompletionBlock)(BOOL success);
typedef void(^MEWWalletCompletionBlock)(BOOL success, NSString *address);
typedef void(^MEWWalletDataCompletionBlock)(id data);

@protocol MEWwallet <NSObject>
- (void) createWalletWithPassword:(NSString *)password mnemonicWords:(NSArray <NSString *> *)mnemonicWords account:(AccountPlainObject *)account;
- (void) createKeysWithChainIDs:(NSSet <NSNumber *> *)chainIDs forAccount:(AccountPlainObject *)account withPassword:(NSString *)password mnemonicWords:(NSArray <NSString *> *)mnemonicWords completion:(MEWwalletCreateCompletionBlock)completion;
- (BOOL) validatePassword:(NSString *)password account:(AccountPlainObject *)account;
- (void) signMessage:(MEWConnectMessage *)message password:(NSString *)password masterToken:(MasterTokenPlainObject *)masterToken completion:(MEWWalletDataCompletionBlock)completion;
- (void) signTransaction:(MEWConnectTransaction *)transaction password:(NSString *)password masterToken:(MasterTokenPlainObject *)masterToken completion:(MEWWalletDataCompletionBlock)completion;
- (BOOL) isSeedAvailableForAccount:(AccountPlainObject *)account;
- (BOOL) validateSeedWithWords:(NSArray <NSString *> *)words withNetwork:(NetworkPlainObject *)network;
- (BOOL) validateMnemonics:(NSArray <NSString *> *)words;
- (NSArray <NSString *> *) recoveryMnemonicsWordsWithPassword:(NSString *)password ofAccount:(AccountPlainObject *)account;
- (NSArray <NSString *> *) obtainBIP32Words;
@end
