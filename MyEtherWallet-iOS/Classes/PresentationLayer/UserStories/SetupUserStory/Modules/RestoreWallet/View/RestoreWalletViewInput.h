//
//  RestoreWalletViewInput.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@protocol RestoreWalletViewInput <NSObject>
- (void) setupInitialState;
- (void) enableNext:(BOOL)enable;
- (void) presentIncorrectMnemonicsWarning;
@end
