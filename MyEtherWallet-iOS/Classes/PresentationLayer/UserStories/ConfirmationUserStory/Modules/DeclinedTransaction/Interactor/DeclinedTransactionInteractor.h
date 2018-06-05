//
//  DeclinedTransactionInteractor.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "DeclinedTransactionInteractorInput.h"

@protocol DeclinedTransactionInteractorOutput;

@interface DeclinedTransactionInteractor : NSObject <DeclinedTransactionInteractorInput>

@property (nonatomic, weak) id<DeclinedTransactionInteractorOutput> output;

@end
