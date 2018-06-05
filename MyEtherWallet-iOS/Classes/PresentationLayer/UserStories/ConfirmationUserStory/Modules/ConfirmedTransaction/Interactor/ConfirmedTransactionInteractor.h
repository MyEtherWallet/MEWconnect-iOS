//
//  ConfirmedTransactionInteractor.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 19/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "ConfirmedTransactionInteractorInput.h"

@protocol ConfirmedTransactionInteractorOutput;

@interface ConfirmedTransactionInteractor : NSObject <ConfirmedTransactionInteractorInput>

@property (nonatomic, weak) id<ConfirmedTransactionInteractorOutput> output;

@end
