//
//  StartRouterInput.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 14/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@protocol StartRouterInput <NSObject>
- (void) openCreateNewWallet;
- (void) openWalletAnimated:(BOOL)animated;
- (void) openRestoreWallet;
@end
