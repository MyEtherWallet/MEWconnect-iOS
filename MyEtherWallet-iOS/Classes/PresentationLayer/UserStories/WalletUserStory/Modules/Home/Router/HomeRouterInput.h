//
//  HomeRouterInput.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@class MEWConnectCommand;

@protocol HomeRouterInput <NSObject>
- (void) openScanner;
- (void) openMessageSignerWithMessage:(MEWConnectCommand *)command;
- (void) openTransactionSignerWithMessage:(MEWConnectCommand *)command;
- (void) openBackup;
@end
