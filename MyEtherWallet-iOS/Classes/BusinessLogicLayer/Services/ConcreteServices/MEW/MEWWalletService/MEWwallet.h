//
//  MEWwallet.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 29/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

#import "BlockchainNetworkTypes.h"

@class MEWConnectTransaction;

typedef void(^MEWWalletCompletionBlock)(BOOL success, NSString *address);
typedef void(^MEWWalletDataCompletionBlock)(id data);

@protocol MEWwallet <NSObject>
- (void) createWalletWithPassword:(NSString *)password words:(NSArray <NSString *> *)words network:(BlockchainNetworkType)network completion:(MEWWalletCompletionBlock)completion;
- (NSString *) validatePassword:(NSString *)password publicAddress:(NSString *)publicAddress network:(BlockchainNetworkType)network;
- (void) signMessage:(NSString *)message password:(NSString *)password publicAddress:(NSString *)publicAddress network:(BlockchainNetworkType)network completion:(MEWWalletDataCompletionBlock)completion;
- (void) signTransaction:(MEWConnectTransaction *)transaction password:(NSString *)password publicAddress:(NSString *)publicAddress network:(BlockchainNetworkType)network completion:(MEWWalletDataCompletionBlock)completion;
- (NSArray <NSString *> *) recoveryMnemonicsWordsWithPassword:(NSString *)password publicAddress:(NSString *)publicAddress network:(BlockchainNetworkType)network;
- (NSArray <NSString *> *) obtainBIP32Words;
@end
