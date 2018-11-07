//
//  BackupWordsInteractor.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 23/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "BackupWordsInteractorInput.h"

@protocol BackupWordsInteractorOutput;
@protocol SecurityService;

@interface BackupWordsInteractor : NSObject <BackupWordsInteractorInput>
@property (nonatomic, weak) id<BackupWordsInteractorOutput> output;
@property (nonatomic, strong) id <SecurityService> securityService;
@end
