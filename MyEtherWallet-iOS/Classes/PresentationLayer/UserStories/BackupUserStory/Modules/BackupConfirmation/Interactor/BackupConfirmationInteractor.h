//
//  BackupConfirmationInteractor.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 23/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "BackupConfirmationInteractorInput.h"

@protocol BackupConfirmationInteractorOutput;
@protocol MEWCrypto;

@interface BackupConfirmationInteractor : NSObject <BackupConfirmationInteractorInput>
@property (nonatomic, weak) id<BackupConfirmationInteractorOutput> output;
@property (nonatomic, strong) id <MEWCrypto> cryptoService;
@end
