//
//  RestorePrepareInteractor.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 18/02/2019.
//  Copyright © 2019 MyEtherWallet, Inc.. All rights reserved.
//

#import "RestorePrepareInteractorInput.h"

@protocol RestorePrepareInteractorOutput;

@interface RestorePrepareInteractor : NSObject <RestorePrepareInteractorInput>

@property (nonatomic, weak) id<RestorePrepareInteractorOutput> output;

@end
