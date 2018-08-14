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
- (InfoNormalTableViewCellObject *) buildContactCellObjectWithCompactSize:(BOOL)compact;
- (InfoNormalTableViewCellObject *) buildKnowledgeBaseCellObjectWithCompactSize:(BOOL)compact;
- (InfoNormalTableViewCellObject *) buildPrivacyAndTermsCellObjectWithCompactSize:(BOOL)compact;
- (InfoNormalTableViewCellObject *) buildMyetherwalletComCellObjectWithCompactSize:(BOOL)compact;
- (InfoNormalTableViewCellObject *) buildUserGuideCellObjectWithCompactSize:(BOOL)compact;
- (InfoNormalTableViewCellObject *) buildAboutCellObjectWithCompactSize:(BOOL)compact;
- (InfoDestructiveTableViewCellObject *) buildResetWalletCellObject;
- (InfoEmptyTableViewCellObject *) buildEmptyCellObject;
@end
