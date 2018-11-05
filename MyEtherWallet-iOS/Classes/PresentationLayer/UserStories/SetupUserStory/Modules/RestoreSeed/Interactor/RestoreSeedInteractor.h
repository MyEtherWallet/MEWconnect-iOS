//
//  RestoreSeedInteractor.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 04/11/2018.
//  Copyright © 2018 MyEtherWallet, Inc.. All rights reserved.
//

#import "RestoreSeedInteractorInput.h"

@protocol MEWwallet;

@protocol RestoreSeedInteractorOutput;

@interface RestoreSeedInteractor : NSObject <RestoreSeedInteractorInput>
@property (nonatomic, weak) id<RestoreSeedInteractorOutput> output;
@property (nonatomic, strong) id<MEWwallet> walletService;
@end
