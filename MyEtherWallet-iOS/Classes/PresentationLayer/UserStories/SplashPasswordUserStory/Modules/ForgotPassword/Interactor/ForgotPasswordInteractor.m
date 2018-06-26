//
//  ForgotPasswordInteractor.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 27/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "ForgotPasswordInteractor.h"

#import "ForgotPasswordInteractorOutput.h"

#import "MEWwallet.h"

@implementation ForgotPasswordInteractor

#pragma mark - ForgotPasswordInteractorInput

- (void)resetWallet {
  [self.walletService resetWallet];
}

@end
