//
//  ContextPasswordInteractorOutput.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 11/09/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@protocol ContextPasswordInteractorOutput <NSObject>
- (void) correctPassword:(NSString *)password;
- (void) incorrectPassword;
@end
