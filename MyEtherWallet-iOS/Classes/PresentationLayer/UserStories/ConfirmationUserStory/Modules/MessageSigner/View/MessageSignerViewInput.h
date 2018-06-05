//
//  MessageSignerViewInput.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 03/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@protocol MessageSignerViewInput <NSObject>
- (void) setupInitialState;
- (void) updateMessage:(NSString *)message;
@end
