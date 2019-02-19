//
//  RestorePreparePresenter.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 18/02/2019.
//  Copyright © 2019 MyEtherWallet, Inc.. All rights reserved.
//

#import "RestorePrepareViewOutput.h"
#import "RestorePrepareInteractorOutput.h"
#import "RestorePrepareModuleInput.h"

@protocol RestorePrepareViewInput;
@protocol RestorePrepareInteractorInput;
@protocol RestorePrepareRouterInput;

@interface RestorePreparePresenter : NSObject <RestorePrepareModuleInput, RestorePrepareViewOutput, RestorePrepareInteractorOutput>

@property (nonatomic, weak) id<RestorePrepareViewInput> view;
@property (nonatomic, strong) id<RestorePrepareInteractorInput> interactor;
@property (nonatomic, strong) id<RestorePrepareRouterInput> router;

@end
