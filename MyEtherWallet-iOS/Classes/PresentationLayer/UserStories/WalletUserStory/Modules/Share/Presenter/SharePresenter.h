//
//  SharePresenter.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 11/10/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "ShareViewOutput.h"
#import "ShareInteractorOutput.h"
#import "ShareModuleInput.h"

@protocol ShareViewInput;
@protocol ShareInteractorInput;
@protocol ShareRouterInput;

@interface SharePresenter : NSObject <ShareModuleInput, ShareViewOutput, ShareInteractorOutput>

@property (nonatomic, weak) id<ShareViewInput> view;
@property (nonatomic, strong) id<ShareInteractorInput> interactor;
@property (nonatomic, strong) id<ShareRouterInput> router;

@end
