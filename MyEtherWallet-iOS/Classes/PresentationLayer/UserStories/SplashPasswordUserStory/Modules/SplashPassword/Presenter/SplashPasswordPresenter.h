//
//  SplashPasswordPresenter.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 26/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "SplashPasswordViewOutput.h"
#import "SplashPasswordInteractorOutput.h"
#import "SplashPasswordModuleInput.h"

@protocol SplashPasswordViewInput;
@protocol SplashPasswordInteractorInput;
@protocol SplashPasswordRouterInput;
@protocol SplashPasswordModuleOutput;

@interface SplashPasswordPresenter : NSObject <SplashPasswordModuleInput, SplashPasswordViewOutput, SplashPasswordInteractorOutput>

@property (nonatomic, weak) id<SplashPasswordViewInput> view;
@property (nonatomic, strong) id<SplashPasswordInteractorInput> interactor;
@property (nonatomic, strong) id<SplashPasswordRouterInput> router;
@property (nonatomic, weak) id<SplashPasswordModuleOutput> moduleOutput;
@end
