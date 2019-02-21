//
//  RestoreOptionsInteractor.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 18/02/2019.
//  Copyright © 2019 MyEtherWallet, Inc.. All rights reserved.
//

#import "RestoreOptionsInteractorInput.h"

@protocol RestoreOptionsInteractorOutput;

@interface RestoreOptionsInteractor : NSObject <RestoreOptionsInteractorInput>

@property (nonatomic, weak) id<RestoreOptionsInteractorOutput> output;

@end
