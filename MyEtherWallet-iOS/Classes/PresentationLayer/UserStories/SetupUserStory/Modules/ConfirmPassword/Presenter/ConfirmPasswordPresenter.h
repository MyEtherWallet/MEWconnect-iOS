//
//  ConfirmPasswordPresenter.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 01/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "ConfirmPasswordViewOutput.h"
#import "ConfirmPasswordInteractorOutput.h"
#import "ConfirmPasswordModuleInput.h"

@protocol ConfirmPasswordViewInput;
@protocol ConfirmPasswordInteractorInput;
@protocol ConfirmPasswordRouterInput;

@interface ConfirmPasswordPresenter : NSObject <ConfirmPasswordModuleInput, ConfirmPasswordViewOutput, ConfirmPasswordInteractorOutput>

@property (nonatomic, weak) id<ConfirmPasswordViewInput> view;
@property (nonatomic, strong) id<ConfirmPasswordInteractorInput> interactor;
@property (nonatomic, strong) id<ConfirmPasswordRouterInput> router;

@end
