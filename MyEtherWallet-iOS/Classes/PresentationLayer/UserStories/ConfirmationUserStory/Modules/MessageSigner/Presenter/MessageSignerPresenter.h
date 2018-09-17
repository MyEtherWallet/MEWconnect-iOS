//
//  MessageSignerPresenter.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 03/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "MessageSignerViewOutput.h"
#import "MessageSignerInteractorOutput.h"
#import "MessageSignerModuleInput.h"
#import "ConfirmationStoryModuleOutput.h"

@protocol MessageSignerViewInput;
@protocol MessageSignerInteractorInput;
@protocol MessageSignerRouterInput;

@interface MessageSignerPresenter : NSObject <MessageSignerModuleInput, MessageSignerViewOutput, MessageSignerInteractorOutput>
@property (nonatomic, weak) id<MessageSignerViewInput> view;
@property (nonatomic, strong) id<MessageSignerInteractorInput> interactor;
@property (nonatomic, strong) id<MessageSignerRouterInput> router;
@property (nonatomic, weak) id <ConfirmationStoryModuleOutput> moduleOutput;
@end
