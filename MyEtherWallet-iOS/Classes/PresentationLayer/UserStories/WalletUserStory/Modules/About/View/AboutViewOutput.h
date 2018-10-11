//
//  AboutViewOutput.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 25/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@protocol AboutViewOutput <NSObject>
- (void) didTriggerViewReadyEvent;
- (void) closeAction;
@end
