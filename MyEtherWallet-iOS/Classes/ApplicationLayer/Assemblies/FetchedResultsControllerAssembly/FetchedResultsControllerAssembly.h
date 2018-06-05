//
//  FetchedResultsControllerAssembly.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 22/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Typhoon;
@import RamblerTyphoonUtils.AssemblyCollector;

@protocol CacheTracker;
@protocol CacheTrackerDelegate;
@class PonsomizerAssembly;

@interface FetchedResultsControllerAssembly : TyphoonAssembly <RamblerInitialAssembly>
@property (nonatomic, strong) PonsomizerAssembly *ponsomizerAssembly;
- (id <CacheTracker>) cacheTrackerWithDelegate:(id <CacheTrackerDelegate>)delegate;
@end

