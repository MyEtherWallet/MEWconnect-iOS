//
//  CacheTrackerImplementation.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 22/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

#import "CacheTracker.h"

@protocol Ponsomizer;

@interface CacheTrackerImplementation : NSObject <CacheTracker>
@property (nonatomic, strong) id <Ponsomizer> ponsomizer;
@end
