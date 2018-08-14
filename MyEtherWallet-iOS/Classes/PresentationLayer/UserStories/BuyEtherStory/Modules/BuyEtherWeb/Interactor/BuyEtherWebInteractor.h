//
//  BuyEtherWebInteractor.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 05/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "BuyEtherWebInteractorInput.h"

@protocol BuyEtherWebInteractorOutput;
@protocol SimplexService;

@interface BuyEtherWebInteractor : NSObject <BuyEtherWebInteractorInput>

@property (nonatomic, weak) id<BuyEtherWebInteractorOutput> output;
@property (nonatomic, strong) id<SimplexService> simplexService;

@end
