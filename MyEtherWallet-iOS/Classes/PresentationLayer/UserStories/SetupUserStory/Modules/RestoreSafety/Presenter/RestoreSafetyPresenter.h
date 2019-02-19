//
//  RestoreSafetyPresenter.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 18/02/2019.
//  Copyright © 2019 MyEtherWallet, Inc.. All rights reserved.
//

#import "RestoreSafetyViewOutput.h"
#import "RestoreSafetyInteractorOutput.h"
#import "RestoreSafetyModuleInput.h"

@protocol RestoreSafetyViewInput;
@protocol RestoreSafetyInteractorInput;
@protocol RestoreSafetyRouterInput;

@interface RestoreSafetyPresenter : NSObject <RestoreSafetyModuleInput, RestoreSafetyViewOutput, RestoreSafetyInteractorOutput>

@property (nonatomic, weak) id<RestoreSafetyViewInput> view;
@property (nonatomic, strong) id<RestoreSafetyInteractorInput> interactor;
@property (nonatomic, strong) id<RestoreSafetyRouterInput> router;

@end
