//
//  BackupInfoInteractor.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 23/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "BackupInfoInteractorInput.h"

@protocol BackupInfoInteractorOutput;

@interface BackupInfoInteractor : NSObject <BackupInfoInteractorInput>

@property (nonatomic, weak) id<BackupInfoInteractorOutput> output;

@end
