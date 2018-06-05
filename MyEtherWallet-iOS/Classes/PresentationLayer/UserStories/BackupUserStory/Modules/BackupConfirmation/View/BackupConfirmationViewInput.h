//
//  BackupConfirmationViewInput.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 23/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@class BackupConfirmationQuiz;

@protocol BackupConfirmationViewInput <NSObject>
- (void) setupInitialStateWithQuiz:(BackupConfirmationQuiz *)quiz;
- (void) enableFinish:(BOOL)enable;
@end
