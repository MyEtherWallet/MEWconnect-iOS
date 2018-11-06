//
//  InfoInteractor.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 24/06/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "InfoInteractor.h"

#import "InfoInteractorOutput.h"

#import "AccountsService.h"
#import "KeychainService.h"

@interface InfoInteractor ()
@end

@implementation InfoInteractor

#pragma mark - InfoInteractorInput

- (void) resetWallet {
  [self.accountsService resetAccounts];
  [self.keychainService resetKeychain];
}

@end
