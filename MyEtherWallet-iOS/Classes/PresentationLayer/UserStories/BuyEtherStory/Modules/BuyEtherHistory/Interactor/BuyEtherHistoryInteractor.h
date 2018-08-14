//
//  BuyEtherHistoryInteractor.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 02/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "BuyEtherHistoryInteractorInput.h"

#import "CacheTracker.h"

@protocol BuyEtherHistoryInteractorOutput;
@protocol SimplexService;
@protocol Ponsomizer;

@interface BuyEtherHistoryInteractor : NSObject <BuyEtherHistoryInteractorInput, CacheTrackerDelegate>
@property (nonatomic, weak) id<BuyEtherHistoryInteractorOutput> output;
@property (nonatomic, strong) id <CacheTracker> cacheTracker;
@property (nonatomic, strong) id <SimplexService> simplexService;
@property (nonatomic, strong) id <Ponsomizer> ponsomizer;
@end
