//
//  RestoreSeedPresenter.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 04/11/2018.
//  Copyright © 2018 MyEtherWallet, Inc.. All rights reserved.
//

#import "RestoreSeedViewOutput.h"
#import "RestoreSeedInteractorOutput.h"
#import "RestoreSeedModuleInput.h"

@protocol RestoreSeedViewInput;
@protocol RestoreSeedInteractorInput;
@protocol RestoreSeedRouterInput;
@protocol RestoreSeedModuleOutput;

@interface RestoreSeedPresenter : NSObject <RestoreSeedModuleInput, RestoreSeedViewOutput, RestoreSeedInteractorOutput>

@property (nonatomic, weak) id<RestoreSeedViewInput> view;
@property (nonatomic, strong) id<RestoreSeedInteractorInput> interactor;
@property (nonatomic, strong) id<RestoreSeedRouterInput> router;
@property (nonatomic, weak) id<RestoreSeedModuleOutput> moduleOutput;

@end
