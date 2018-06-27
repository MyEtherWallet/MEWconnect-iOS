//
//  InfoInteractor.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 24/06/2018.
//  Copyright © 2018 MyEtherWallet, Inc.. All rights reserved.
//

#import "InfoInteractor.h"

#import "InfoInteractorOutput.h"

#import "MEWwallet.h"

@implementation InfoInteractor

#pragma mark - InfoInteractorInput

- (void) resetWallet {
  [self.walletService resetWallet];
}

@end
