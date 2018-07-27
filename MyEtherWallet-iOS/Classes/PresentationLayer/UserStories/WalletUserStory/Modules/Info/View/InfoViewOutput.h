//
//  InfoViewOutput.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 24/06/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@protocol InfoViewOutput <NSObject>
- (void) didTriggerViewReadyEvent;
- (void) closeAction;
- (void) contactAction;
- (void) knowledgeBaseAction;
- (void) privacyAndTermsAction;
- (void) myEtherWalletComAction;
- (void) userGuideAction;
- (void) resetWalletAction;
- (void) resetWalletConfirmedAction;
- (void) aboutAction;
@end
