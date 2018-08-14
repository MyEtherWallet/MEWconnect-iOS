//
//  InfoPresenter.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 24/06/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "InfoViewOutput.h"
#import "InfoInteractorOutput.h"
#import "InfoModuleInput.h"

@protocol InfoViewInput;
@protocol InfoInteractorInput;
@protocol InfoRouterInput;

@interface InfoPresenter : NSObject <InfoModuleInput, InfoViewOutput, InfoInteractorOutput>

@property (nonatomic, weak) id<InfoViewInput> view;
@property (nonatomic, strong) id<InfoInteractorInput> interactor;
@property (nonatomic, strong) id<InfoRouterInput> router;

@end
