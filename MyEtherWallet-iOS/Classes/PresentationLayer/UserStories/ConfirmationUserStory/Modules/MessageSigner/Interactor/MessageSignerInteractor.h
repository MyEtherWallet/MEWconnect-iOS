//
//  MessageSignerInteractor.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 03/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "MessageSignerInteractorInput.h"

@protocol MessageSignerInteractorOutput;

@protocol MEWWallet;

@interface MessageSignerInteractor : NSObject <MessageSignerInteractorInput>
@property (nonatomic, weak) id<MessageSignerInteractorOutput> output;
@property (nonatomic, strong) id <MEWWallet> walletService;
@end
