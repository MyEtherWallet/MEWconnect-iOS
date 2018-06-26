//
//  SplashPasswordInteractor.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 26/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "SplashPasswordInteractorInput.h"

@protocol SplashPasswordInteractorOutput;
@protocol MEWwallet;

@interface SplashPasswordInteractor : NSObject <SplashPasswordInteractorInput>
@property (nonatomic, weak) id <SplashPasswordInteractorOutput> output;
@property (nonatomic, strong) id <MEWwallet> walletService;
@end
