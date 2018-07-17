//
//  BackupInfoInteractor.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 23/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "BackupInfoInteractor.h"

#import "BackupInfoInteractorOutput.h"

@interface BackupInfoInteractor ()
@property (nonatomic, strong) AccountPlainObject *account;
@end

@implementation BackupInfoInteractor

#pragma mark - BackupInfoInteractorInput

- (void) configurateWithAccount:(AccountPlainObject *)account {
  self.account = account;
}

- (AccountPlainObject *) obtainAccount {
  return self.account;
}

@end
