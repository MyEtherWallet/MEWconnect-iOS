//
//  InfoCellObjectBuilder.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 24/06/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@class InfoNormalTableViewCellObject;
@class InfoDestructiveTableViewCellObject;
@class InfoEmptyTableViewCellObject;

@interface InfoCellObjectBuilder : NSObject
- (InfoNormalTableViewCellObject *) buildContactCellObject;
- (InfoNormalTableViewCellObject *) buildKnowledgeBaseCellObject;
- (InfoNormalTableViewCellObject *) buildPrivacyAndTermsCellObject;
- (InfoNormalTableViewCellObject *) buildMyetherwalletComCellObject;
- (InfoDestructiveTableViewCellObject *) buildResetWalletCellObject;
- (InfoEmptyTableViewCellObject *) buildEmptyCellObject;
@end
