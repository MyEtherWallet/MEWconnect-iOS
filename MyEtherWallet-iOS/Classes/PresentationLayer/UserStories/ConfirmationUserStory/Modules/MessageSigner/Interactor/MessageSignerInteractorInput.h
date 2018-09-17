//
//  MessageSignerInteractorInput.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 03/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@class MEWConnectCommand;
@class MEWConnectMessage;
@class AccountPlainObject;

@protocol MessageSignerInteractorInput <NSObject>
- (void) configurateWithMessage:(MEWConnectCommand *)message account:(AccountPlainObject *)account;;
- (MEWConnectMessage *) obtainMessage;
- (AccountPlainObject *) obtainAccount;
- (void) signMessageWithPassword:(NSString *)password;
@end
