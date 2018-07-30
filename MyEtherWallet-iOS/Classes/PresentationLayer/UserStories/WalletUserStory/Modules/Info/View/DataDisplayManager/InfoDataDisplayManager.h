//
//  InfoDataDisplayManager.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 24/06/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

#import "DataDisplayManager.h"

@class InfoCellObjectBuilder;

@protocol InfoDataDisplayManagerDelegate <NSObject>
- (void) didTapContact;
- (void) didTapKnowledgeBase;
- (void) didTapPrivacyAndTerms;
- (void) didTapMyEtherWalletCom;
- (void) didTapResetWallet;
- (void) didTapUserGuide;
- (void) didTapAbout;
@end

@interface InfoDataDisplayManager : NSObject <DataDisplayManager, UITableViewDelegate>
@property (nonatomic, weak) id <InfoDataDisplayManagerDelegate> delegate;
@property (nonatomic, strong) InfoCellObjectBuilder* cellObjectBuilder;
- (void) updateDataDisplayManager;
@end
