//
//  ContextPasswordViewInput.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 11/09/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@protocol ContextPasswordViewInput <NSObject>
- (void) setupInitialStateWithTitle:(NSString *)title;
- (void) shakeInput;
- (void) prepareForDismiss;
@end
