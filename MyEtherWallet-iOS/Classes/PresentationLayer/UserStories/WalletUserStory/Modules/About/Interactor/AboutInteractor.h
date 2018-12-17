//
//  AboutInteractor.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 25/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "AboutInteractorInput.h"

@protocol AboutInteractorOutput;

@interface AboutInteractor : NSObject <AboutInteractorInput>

@property (nonatomic, weak) id<AboutInteractorOutput> output;

@end
