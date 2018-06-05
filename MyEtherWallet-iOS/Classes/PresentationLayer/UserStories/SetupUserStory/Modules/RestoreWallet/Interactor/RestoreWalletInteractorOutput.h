//
//  RestoreWalletInteractorOutput.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@protocol RestoreWalletInteractorOutput <NSObject>
- (void) allowRestore;
- (void) disallowRestore;
- (void) openPasswordWithWords:(NSArray <NSString *> *)words;
- (void) restoreNotPossible;
@end
