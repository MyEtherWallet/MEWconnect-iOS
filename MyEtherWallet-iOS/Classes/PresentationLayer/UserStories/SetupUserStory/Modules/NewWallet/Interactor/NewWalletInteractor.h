//
//  NewWalletInteractor.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "NewWalletInteractorInput.h"

@protocol NewWalletInteractorOutput;
@protocol BlockchainNetworkService;
@protocol AccountsService;
@protocol Ponsomizer;
@protocol MEWConnectFacade;

@interface NewWalletInteractor : NSObject <NewWalletInteractorInput>

@property (nonatomic, weak) id<NewWalletInteractorOutput> output;
@property (nonatomic, strong) id <BlockchainNetworkService> blockchainNetworkService;
@property (nonatomic, strong) id <AccountsService> accountsService;
@property (nonatomic, strong) id <Ponsomizer> ponsomizer;
@property (nonatomic, strong) id <MEWConnectFacade> connectFacade;
@end
