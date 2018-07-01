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

#import "BlockchainNetworkService.h"
#import "AccountsService.h"
#import "Ponsomizer.h"

#import "NetworkPlainObject.h"
#import "AccountPlainObject.h"

#import "UIImage+MEWBackground.h"
#import "UIImage+MEWBackground.h"

@interface NewWalletInteractor ()
@end

@implementation NewWalletInteractor

#pragma mark - NewWalletInteractorInput

- (void) createNewWalletWithPassword:(NSString *)password words:(NSArray<NSString *> *)words {
  @weakify(self);
  NetworkModelObject *networkModelObject = [self.blockchainNetworkService obtainActiveNetwork];
  
  NSArray *ignoringProperties = @[NSStringFromSelector(@selector(accounts))];
  NetworkPlainObject *network = [self.ponsomizer convertObject:networkModelObject ignoringProperties:ignoringProperties];
  
  [self.accountsService createNewAccountInNetwork:network password:password words:words completion:^(AccountModelObject *accountModelObject) {
    @strongify(self);
    
    NSArray *ignoringProperties = @[NSStringFromSelector(@selector(backedUp)),
                                    NSStringFromSelector(@selector(fromNetwork)),
                                    NSStringFromSelector(@selector(price)),
                                    NSStringFromSelector(@selector(tokens))];
    AccountPlainObject *account = [self.ponsomizer convertObject:accountModelObject ignoringProperties:ignoringProperties];
    
    CGSize fullSize = [UIImage fullSize];
    CGSize cardSize = [UIImage cardSize];
    [UIImage cacheImagesWithSeed:account.publicAddress fullSize:fullSize cardSize:cardSize];
  }];
}

@end
