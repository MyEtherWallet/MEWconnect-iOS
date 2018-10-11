//
//  ShareInteractor.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 11/10/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "ShareInteractorInput.h"

@protocol ShareInteractorOutput;

@interface ShareInteractor : NSObject <ShareInteractorInput>

@property (nonatomic, weak) id<ShareInteractorOutput> output;

@end
