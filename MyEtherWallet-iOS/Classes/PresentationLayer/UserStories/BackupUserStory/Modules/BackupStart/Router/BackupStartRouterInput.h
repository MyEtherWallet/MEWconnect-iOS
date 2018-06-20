//
//  BackupStartRouterInput.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 23/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@protocol SplashPasswordModuleOutput;

@protocol BackupStartRouterInput <NSObject>
- (void) openSplashPasswordWithOutput:(id <SplashPasswordModuleOutput>)output;
- (void) openWordsWithMnemonics:(NSArray <NSString *> *)mnemonics;
@end
