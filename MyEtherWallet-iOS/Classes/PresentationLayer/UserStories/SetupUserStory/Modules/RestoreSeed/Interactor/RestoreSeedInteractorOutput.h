//
//  RestoreSeedInteractorOutput.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 04/11/2018.
//  Copyright © 2018 MyEtherWallet, Inc.. All rights reserved.
//

@import Foundation;

@protocol RestoreSeedInteractorOutput <NSObject>
- (void) allowRestore;
- (void) disallowRestore;
- (void) restoreNotPossible;
- (void) invalidMnemonics;
- (void) validMnemonicsWithPassword:(NSString *)password;
@end
