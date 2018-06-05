//
//  RestoreWalletInteractorInput.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@protocol RestoreWalletInteractorInput <NSObject>
- (void) configurate;
- (void) checkMnemonics:(NSString *)mnemonics;
- (void) tryRestore;
@end
