//
//  SplashPasswordInteractor.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 26/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "SplashPasswordInteractorInput.h"

@protocol SplashPasswordInteractorOutput;
@protocol AccountsService;
@protocol MEWwallet;
@protocol Ponsomizer;

@interface SplashPasswordInteractor : NSObject <SplashPasswordInteractorInput>
@property (nonatomic, weak) id <SplashPasswordInteractorOutput> output;
@property (nonatomic, strong) id <AccountsService> accountsService;
@property (nonatomic, strong) id <MEWwallet> walletService;
@property (nonatomic, strong) id <Ponsomizer> ponsomizer;
@end
