//
//  NewWalletInteractor.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import libextobjc.EXTScope;

#import "NewWalletInteractor.h"

#import "NewWalletInteractorOutput.h"

#import "MEWCrypto.h"
#import "TokensService.h"

#import "UIImage+MEWBackground.h"
#import "UIImage+MEWBackground.h"

@interface NewWalletInteractor ()
@property (nonatomic, strong) NSString *address;
@end

@implementation NewWalletInteractor

#pragma mark - NewWalletInteractorInput

- (void) createNewWalletWithPassword:(NSString *)password words:(NSArray<NSString *> *)words {
  @weakify(self);
  [self.tokensService clearTokens];
  [self.cryptoService createWalletWithPassword:password words:words completion:^(BOOL success, NSString *address) {
    @strongify(self);
    CGSize fullSize = [UIImage fullSize];
    CGSize cardSize = [UIImage cardSize];
    [UIImage cacheImagesWithSeed:address fullSize:fullSize cardSize:cardSize];
    self.address = address;
  }];
}

- (NSString *)obtainWalletAddress {
  return self.address;
}

@end
