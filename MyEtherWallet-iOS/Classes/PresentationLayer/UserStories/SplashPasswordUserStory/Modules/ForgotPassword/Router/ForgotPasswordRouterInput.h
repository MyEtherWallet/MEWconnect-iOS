//
//  ForgotPasswordRouterInput.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 27/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@protocol ForgotPasswordRouterInput <NSObject>
- (void) close;
- (void) openRestore;
- (void) unwindToStart;
@end
