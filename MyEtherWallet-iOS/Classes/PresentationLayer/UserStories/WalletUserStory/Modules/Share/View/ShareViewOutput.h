//
//  ShareViewOutput.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 11/10/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@protocol ShareViewOutput <NSObject>
- (void) didTriggerViewReadyEvent;
- (void) didTriggerViewWillAppearEvent;
- (void) didTriggerViewWillDisappearEvent;
- (void) closeAction;
- (void) copyAction;
- (void) shareAction;
@end
