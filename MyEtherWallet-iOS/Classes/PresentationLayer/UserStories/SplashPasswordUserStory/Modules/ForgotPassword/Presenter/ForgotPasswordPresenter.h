//
//  ForgotPasswordPresenter.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 27/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "ForgotPasswordViewOutput.h"
#import "ForgotPasswordInteractorOutput.h"
#import "ForgotPasswordModuleInput.h"

@protocol ForgotPasswordViewInput;
@protocol ForgotPasswordInteractorInput;
@protocol ForgotPasswordRouterInput;

@interface ForgotPasswordPresenter : NSObject <ForgotPasswordModuleInput, ForgotPasswordViewOutput, ForgotPasswordInteractorOutput>

@property (nonatomic, weak) id<ForgotPasswordViewInput> view;
@property (nonatomic, strong) id<ForgotPasswordInteractorInput> interactor;
@property (nonatomic, strong) id<ForgotPasswordRouterInput> router;

@end
