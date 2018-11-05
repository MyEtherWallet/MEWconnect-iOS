//
//  ContextPasswordModuleInput.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 11/09/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;
@import ViperMcFlurryX;

@class AccountPlainObject;

typedef NS_ENUM(short, ContextPasswordType) {
  ContextPasswordTypeBackup       = 0,
  ContextPasswordTypeTransaction  = 1,
  ContextPasswordTypeMessage      = 2,
  ContextPasswordTypeGenerate     = 3,
};

@protocol ContextPasswordModuleInput <RamblerViperModuleInput>
- (void) configureModuleWithAccount:(AccountPlainObject *)account type:(ContextPasswordType)type;
@end
