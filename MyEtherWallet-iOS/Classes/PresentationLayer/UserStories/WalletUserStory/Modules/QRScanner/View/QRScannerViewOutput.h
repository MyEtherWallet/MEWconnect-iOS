//
//  QRScannerViewOutput.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@protocol QRScannerViewOutput <NSObject>
- (void) didTriggerViewReadyEvent;
- (void) didTriggerViewWillAppear;
- (void) didTriggerViewDidAppear;
- (void) didTriggerViewDidDisappear;
- (void) closeAction;
- (void) settingsAction;
- (void) contactSupportAction;
@end
