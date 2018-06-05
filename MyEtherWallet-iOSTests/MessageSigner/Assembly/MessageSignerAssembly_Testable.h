//
//  MessageSignerAssembly_Testable.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 03/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "MessageSignerAssembly.h"

@class MessageSignerViewController;
@class MessageSignerInteractor;
@class MessageSignerPresenter;
@class MessageSignerRouter;

@interface MessageSignerAssembly ()

- (MessageSignerViewController *)viewMessageSigner;
- (MessageSignerPresenter *)presenterMessageSigner;
- (MessageSignerInteractor *)interactorMessageSigner;
- (MessageSignerRouter *)routerMessageSigner;

@end
