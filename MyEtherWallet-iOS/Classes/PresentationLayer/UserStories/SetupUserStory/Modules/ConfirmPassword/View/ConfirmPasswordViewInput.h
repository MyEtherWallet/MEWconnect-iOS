//
//  ConfirmPasswordViewInput.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 01/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@protocol ConfirmPasswordViewInput <NSObject>
- (void) setupInitialState;
- (void) showValidPasswordInput;
- (void) showInvalidPasswordInput;
- (void) disableNext;
- (void) enableNext;
@end
