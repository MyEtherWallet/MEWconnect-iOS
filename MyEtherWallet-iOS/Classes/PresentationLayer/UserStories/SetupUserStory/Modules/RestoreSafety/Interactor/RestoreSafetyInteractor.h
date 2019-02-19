//
//  RestoreSafetyInteractor.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 18/02/2019.
//  Copyright © 2019 MyEtherWallet, Inc.. All rights reserved.
//

#import "RestoreSafetyInteractorInput.h"

@protocol RestoreSafetyInteractorOutput;

@interface RestoreSafetyInteractor : NSObject <RestoreSafetyInteractorInput>

@property (nonatomic, weak) id<RestoreSafetyInteractorOutput> output;

@end
