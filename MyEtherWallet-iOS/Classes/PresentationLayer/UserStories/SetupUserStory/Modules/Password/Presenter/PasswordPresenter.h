//
//  PasswordPresenter.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "PasswordViewOutput.h"
#import "PasswordInteractorOutput.h"
#import "PasswordModuleInput.h"

@protocol PasswordViewInput;
@protocol PasswordInteractorInput;
@protocol PasswordRouterInput;

@interface PasswordPresenter : NSObject <PasswordModuleInput, PasswordViewOutput, PasswordInteractorOutput>

@property (nonatomic, weak) id<PasswordViewInput> view;
@property (nonatomic, strong) id<PasswordInteractorInput> interactor;
@property (nonatomic, strong) id<PasswordRouterInput> router;

@end
