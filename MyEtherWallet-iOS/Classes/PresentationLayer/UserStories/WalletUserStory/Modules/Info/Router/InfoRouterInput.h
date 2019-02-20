//
//  InfoRouterInput.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 24/06/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@class AccountPlainObject;
@protocol ContextPasswordModuleOutput;

@protocol InfoRouterInput <NSObject>
- (void) close;
- (void) unwindToStart;
- (void) openMyEtherWalletCom;
- (void) openKnowledgeBase;
- (void) openPrivacyAndTerms;
- (void) openUserGuide;
- (void) openAbout;
- (void) openWordsWithMnemonics:(NSArray<NSString *> *)mnemonics;
- (void) openContextPasswordWithOutput:(id <ContextPasswordModuleOutput>)output account:(AccountPlainObject *)account;
- (void) openBackupWithAccount:(AccountPlainObject *)account;
@end
