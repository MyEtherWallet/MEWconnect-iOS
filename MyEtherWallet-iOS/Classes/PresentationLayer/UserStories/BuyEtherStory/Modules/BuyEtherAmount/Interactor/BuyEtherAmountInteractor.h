//
//  BuyEtherAmountInteractor.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 02/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "BuyEtherAmountInteractorInput.h"

@protocol BuyEtherAmountInteractorOutput;
@protocol SimplexService;

@interface BuyEtherAmountInteractor : NSObject <BuyEtherAmountInteractorInput>

@property (nonatomic, weak) id <BuyEtherAmountInteractorOutput> output;
@property (nonatomic, strong) id <SimplexService> simplexService;
@end
