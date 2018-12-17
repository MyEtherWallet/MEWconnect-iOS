//
//  ContextPasswordInteractor.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 11/09/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "ContextPasswordInteractorInput.h"

@protocol ContextPasswordInteractorOutput;
@protocol AccountsService;
@protocol MEWwallet;
@protocol Ponsomizer;

@interface ContextPasswordInteractor : NSObject <ContextPasswordInteractorInput>
@property (nonatomic, weak) id<ContextPasswordInteractorOutput> output;
@property (nonatomic, strong) id <AccountsService> accountsService;
@property (nonatomic, strong) id <MEWwallet> walletService;
@property (nonatomic, strong) id <Ponsomizer> ponsomizer;
@end
