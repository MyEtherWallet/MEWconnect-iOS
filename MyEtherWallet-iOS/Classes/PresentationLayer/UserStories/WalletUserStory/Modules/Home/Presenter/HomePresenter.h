//
//  HomePresenter.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "HomeViewOutput.h"
#import "HomeInteractorOutput.h"
#import "HomeModuleInput.h"

@protocol HomeViewInput;
@protocol HomeInteractorInput;
@protocol HomeRouterInput;

@interface HomePresenter : NSObject <HomeModuleInput, HomeViewOutput, HomeInteractorOutput>

@property (nonatomic, weak) id<HomeViewInput> view;
@property (nonatomic, strong) id<HomeInteractorInput> interactor;
@property (nonatomic, strong) id<HomeRouterInput> router;

@end
