//
//  ContextPasswordModuleOutput.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 11/09/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;
@import ViperMcFlurryX;

#import "EnterPasswordProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ContextPasswordModuleOutput <RamblerViperModuleOutput, EnterPasswordProtocol>

@end

NS_ASSUME_NONNULL_END
