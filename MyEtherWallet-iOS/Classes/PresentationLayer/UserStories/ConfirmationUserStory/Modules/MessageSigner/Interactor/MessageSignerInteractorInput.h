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
@class MasterTokenPlainObject;
@class AccountPlainObject;

@protocol MessageSignerInteractorInput <NSObject>
- (void) configurateWithMessage:(MEWConnectCommand *)message masterToken:(MasterTokenPlainObject *)masterToken;
- (MEWConnectMessage *) obtainMessage;
- (AccountPlainObject *) obtainAccount;
- (void) signMessageWithPassword:(NSString *)password;
@end
