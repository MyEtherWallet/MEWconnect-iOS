//
//  MessageSignerInteractorInput.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 03/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@class MEWConnectCommand;

@protocol MessageSignerInteractorInput <NSObject>
- (void) configurateWithMessage:(MEWConnectCommand *)message;
- (NSString *) obtainMessage;
- (void) signMessage;
@end
