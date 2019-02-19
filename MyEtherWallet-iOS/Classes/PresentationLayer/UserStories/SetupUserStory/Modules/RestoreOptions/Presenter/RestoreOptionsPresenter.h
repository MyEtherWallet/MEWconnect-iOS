//
//  RestoreOptionsPresenter.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 18/02/2019.
//  Copyright © 2019 MyEtherWallet, Inc.. All rights reserved.
//

#import "RestoreOptionsViewOutput.h"
#import "RestoreOptionsInteractorOutput.h"
#import "RestoreOptionsModuleInput.h"

@protocol RestoreOptionsViewInput;
@protocol RestoreOptionsInteractorInput;
@protocol RestoreOptionsRouterInput;

@interface RestoreOptionsPresenter : NSObject <RestoreOptionsModuleInput, RestoreOptionsViewOutput, RestoreOptionsInteractorOutput>

@property (nonatomic, weak) id<RestoreOptionsViewInput> view;
@property (nonatomic, strong) id<RestoreOptionsInteractorInput> interactor;
@property (nonatomic, strong) id<RestoreOptionsRouterInput> router;

@end
