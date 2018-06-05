//
//  SettingsInteractor.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "SettingsInteractorInput.h"

@protocol SettingsInteractorOutput;

@interface SettingsInteractor : NSObject <SettingsInteractorInput>

@property (nonatomic, weak) id<SettingsInteractorOutput> output;

@end
