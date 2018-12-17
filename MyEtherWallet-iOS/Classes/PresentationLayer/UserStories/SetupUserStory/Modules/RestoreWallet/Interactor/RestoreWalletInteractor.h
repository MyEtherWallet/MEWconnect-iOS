//
//  RestoreWalletInteractor.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "RestoreWalletInteractorInput.h"

@protocol MEWwallet;

@protocol RestoreWalletInteractorOutput;
@protocol ObjectValidator;

@interface RestoreWalletInteractor : NSObject <RestoreWalletInteractorInput>
@property (nonatomic, weak) id<RestoreWalletInteractorOutput> output;
@property (nonatomic, strong) id<MEWwallet> walletService;
@property (nonatomic, strong) id<ObjectValidator> mnemonicsValidator;
@end
