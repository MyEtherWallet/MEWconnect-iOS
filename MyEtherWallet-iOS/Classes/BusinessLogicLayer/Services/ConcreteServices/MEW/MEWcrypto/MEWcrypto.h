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
- (void) configurateWithConnectionPrivateKey:(NSData *)connectionPrivateKey;
- (nullable MEWcryptoMessage *) encryptMessage:(NSData *)message;
- (nullable NSData *) decryptMessage:(MEWcryptoMessage *)message;
@end

NS_ASSUME_NONNULL_END
