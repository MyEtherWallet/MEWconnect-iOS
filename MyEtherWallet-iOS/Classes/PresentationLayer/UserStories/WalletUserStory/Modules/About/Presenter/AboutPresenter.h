//
//  AboutPresenter.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 25/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "AboutViewOutput.h"
#import "AboutInteractorOutput.h"
#import "AboutModuleInput.h"

@protocol AboutViewInput;
@protocol AboutInteractorInput;
@protocol AboutRouterInput;

@interface AboutPresenter : NSObject <AboutModuleInput, AboutViewOutput, AboutInteractorOutput>

@property (nonatomic, weak) id<AboutViewInput> view;
@property (nonatomic, strong) id<AboutInteractorInput> interactor;
@property (nonatomic, strong) id<AboutRouterInput> router;

@end
