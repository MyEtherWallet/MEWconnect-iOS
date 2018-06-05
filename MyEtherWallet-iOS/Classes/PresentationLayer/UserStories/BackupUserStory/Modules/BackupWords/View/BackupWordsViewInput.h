//
//  BackupWordsViewInput.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 23/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@protocol BackupWordsViewInput <NSObject>
- (void) setupInitialStateWithWords:(NSArray <NSString *> *)words;
- (void) showScreenshotAlert;
@end
