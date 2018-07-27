//
//  ConfirmationNavigationPresenter.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 17/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "ConfirmationNavigationViewOutput.h"
#import "ConfirmationNavigationModuleInput.h"

@protocol ConfirmationNavigationViewInput;
@protocol ConfirmationNavigationRouterInput;

@interface ConfirmationNavigationPresenter : NSObject <ConfirmationNavigationModuleInput, ConfirmationNavigationViewOutput>

@property (nonatomic, weak) id<ConfirmationNavigationViewInput> view;
@property (nonatomic, strong) id<ConfirmationNavigationRouterInput> router;

@end
