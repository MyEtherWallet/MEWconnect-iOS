//
//  BackupStartInteractor.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 23/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "BackupStartInteractorInput.h"

@protocol BackupStartInteractorOutput;
@protocol AccountsService;

@interface BackupStartInteractor : NSObject <BackupStartInteractorInput>
@property (nonatomic, weak) id<BackupStartInteractorOutput> output;
@property (nonatomic, strong) id <MEWwallet> walletService;
@end
