//
//  HomeInteractor.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "HomeInteractorInput.h"

#import "CacheTracker.h"

@protocol HomeInteractorOutput;
@protocol MEWConnectFacade;
@protocol TokensService;
@protocol CacheTracker;
@protocol Ponsomizer;
@protocol BlockchainNetworkService;
@protocol AccountsService;
@protocol FiatPricesService;

@interface HomeInteractor : NSObject <HomeInteractorInput, CacheTrackerDelegate>
@property (nonatomic, weak) id<HomeInteractorOutput> output;
@property (nonatomic, strong) id <MEWConnectFacade> connectFacade;
@property (nonatomic, strong) id <TokensService> tokensService;
@property (nonatomic, strong) id <CacheTracker> cacheTracker;
@property (nonatomic, strong) id <Ponsomizer> ponsomizer;
@property (nonatomic, strong) id <BlockchainNetworkService> blockchainNetworkService;
@property (nonatomic, strong) id <AccountsService> accountsService;
@property (nonatomic, strong) id <FiatPricesService> fiatPricesService;
@end
