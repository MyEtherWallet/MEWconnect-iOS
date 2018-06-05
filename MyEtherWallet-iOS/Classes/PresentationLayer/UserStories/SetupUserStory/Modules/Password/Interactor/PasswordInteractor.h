//
//  PasswordInteractor.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "PasswordInteractorInput.h"

@protocol PasswordInteractorOutput;
@class DBZxcvbn;

@interface PasswordInteractor : NSObject <PasswordInteractorInput>
@property (nonatomic, weak) id<PasswordInteractorOutput> output;
@property (nonatomic, strong) DBZxcvbn *zxcvbn;
@end
