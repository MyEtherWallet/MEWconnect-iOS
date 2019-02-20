//
//  InfoInteractor.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 24/06/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "InfoInteractorInput.h"

@protocol InfoInteractorOutput;
@protocol AccountsService;
@protocol KeychainService;
@protocol TokensService;
@protocol MEWwallet;
@protocol Ponsomizer;

@interface InfoInteractor : NSObject <InfoInteractorInput>
@property (nonatomic, weak) id<InfoInteractorOutput> output;
@property (nonatomic, strong) id <AccountsService> accountsService;
@property (nonatomic, strong) id <KeychainService> keychainService;
@property (nonatomic, strong) id <TokensService> tokensService;
@property (nonatomic, strong) id <MEWwallet> walletService;
@property (nonatomic, strong) id <Ponsomizer> ponsomizer;
@end
