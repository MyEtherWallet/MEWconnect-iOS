//
//  NewWalletInteractor.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "NewWalletInteractorInput.h"

@protocol NewWalletInteractorOutput;
@protocol MEWWallet;
@protocol TokensService;

@interface NewWalletInteractor : NSObject <NewWalletInteractorInput>

@property (nonatomic, weak) id<NewWalletInteractorOutput> output;
@property (nonatomic, strong) id <MEWWallet> walletService;
@property (nonatomic, strong) id <TokensService> tokensService;
@end
