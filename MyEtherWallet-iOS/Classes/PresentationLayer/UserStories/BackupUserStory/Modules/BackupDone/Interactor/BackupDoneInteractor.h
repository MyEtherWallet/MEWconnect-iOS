//
//  BackupDoneInteractor.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 23/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "BackupDoneInteractorInput.h"

@protocol BackupDoneInteractorOutput;

@interface BackupDoneInteractor : NSObject <BackupDoneInteractorInput>

@property (nonatomic, weak) id<BackupDoneInteractorOutput> output;

@end
