//
//  StartInteractor.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 14/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "StartInteractorInput.h"

@protocol StartInteractorOutput;

@protocol MEWCrypto;

@interface StartInteractor : NSObject <StartInteractorInput>
@property (nonatomic, weak) id<StartInteractorOutput> output;
@property (nonatomic, strong) id <MEWCrypto> cryptoService;
@end
