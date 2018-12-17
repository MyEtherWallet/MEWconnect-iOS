//
//  RestoreSeedViewOutput.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 04/11/2018.
//  Copyright © 2018 MyEtherWallet, Inc.. All rights reserved.
//

@import Foundation;

@protocol RestoreSeedViewOutput <NSObject>
- (void) didTriggerViewReadyEvent;
- (void) cancelAction;
- (void) nextAction;
- (void) textDidChangedAction:(NSString *)text;
@end
