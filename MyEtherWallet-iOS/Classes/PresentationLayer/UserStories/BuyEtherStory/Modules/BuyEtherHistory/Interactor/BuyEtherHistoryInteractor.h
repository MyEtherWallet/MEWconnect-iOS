//
//  BuyEtherHistoryInteractor.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 02/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "BuyEtherHistoryInteractorInput.h"

@protocol BuyEtherHistoryInteractorOutput;

@interface BuyEtherHistoryInteractor : NSObject <BuyEtherHistoryInteractorInput>

@property (nonatomic, weak) id<BuyEtherHistoryInteractorOutput> output;

@end
