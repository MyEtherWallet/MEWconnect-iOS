//
//  MEWcrypto.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 17/06/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@class MEWcryptoMessage;

NS_ASSUME_NONNULL_BEGIN

@protocol MEWcrypto <NSObject>
#pragma mark - MEWconnect protocol
- (void) configurateWithConnectionPrivateKey:(NSData *)connectionPrivateKey;
- (nullable MEWcryptoMessage *) encryptMessage:(NSData *)message;
- (nullable NSData *) decryptMessage:(MEWcryptoMessage *)message;
#pragma mark - Ethereum Signing Message
- (nullable NSData *) hashPersonalMessage:(NSData *)message;
#pragma mark - AES-256 + SHA3 Encryption
- (nullable NSData *) encryptData:(NSData *)data withPassword:(NSString *)password;
- (nullable NSData *) decryptData:(NSData *)data withPassword:(NSString *)password;
@end

NS_ASSUME_NONNULL_END
