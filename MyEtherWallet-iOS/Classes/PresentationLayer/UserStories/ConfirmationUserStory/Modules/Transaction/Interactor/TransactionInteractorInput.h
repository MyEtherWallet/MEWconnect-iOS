//
//  TransactionInteractorInput.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@class MEWConnectCommand;
@class MEWConnectTransaction;

@protocol TransactionInteractorInput <NSObject>
- (void) configurateWithMessage:(MEWConnectCommand *)message;
- (MEWConnectTransaction *) obtainTransaction;
- (void) signTransactionWithPassword:(NSString *)password;
@end
