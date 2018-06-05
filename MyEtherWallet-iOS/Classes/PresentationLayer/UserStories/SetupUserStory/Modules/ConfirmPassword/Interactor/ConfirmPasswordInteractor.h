//
//  ConfirmPasswordInteractor.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 01/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "ConfirmPasswordInteractorInput.h"

@protocol ConfirmPasswordInteractorOutput;

@interface ConfirmPasswordInteractor : NSObject <ConfirmPasswordInteractorInput>

@property (nonatomic, weak) id<ConfirmPasswordInteractorOutput> output;

@end
