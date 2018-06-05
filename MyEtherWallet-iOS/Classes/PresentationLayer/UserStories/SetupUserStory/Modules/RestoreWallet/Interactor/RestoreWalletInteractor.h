//
//  RestoreWalletInteractor.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "RestoreWalletInteractorInput.h"

@protocol MEWCrypto;

@protocol RestoreWalletInteractorOutput;

@interface RestoreWalletInteractor : NSObject <RestoreWalletInteractorInput>
@property (nonatomic, weak) id<RestoreWalletInteractorOutput> output;
@property (nonatomic, strong) id<MEWCrypto> cryptoService;
@end
