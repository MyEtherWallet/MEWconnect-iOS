//
//  InfoCellObjectBuilder.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 24/06/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "InfoCellObjectBuilder.h"

#import "InfoNormalTableViewCellObject.h"
#import "InfoDestructiveTableViewCellObject.h"
#import "InfoEmptyTableViewCellObject.h"

@implementation InfoCellObjectBuilder

- (InfoNormalTableViewCellObject *) buildContactCellObject {
  return [InfoNormalTableViewCellObject objectWithType:InfoNormalTableViewCellObjectTypeContact];
}

- (InfoNormalTableViewCellObject *) buildKnowledgeBaseCellObject {
  return [InfoNormalTableViewCellObject objectWithType:InfoNormalTableViewCellObjectTypeKnowledgeBase];
}

- (InfoNormalTableViewCellObject *) buildPrivacyAndTermsCellObject {
  return [InfoNormalTableViewCellObject objectWithType:InfoNormalTableViewCellObjectTypePrivateAndTerms];
}

- (InfoNormalTableViewCellObject *) buildMyetherwalletComCellObject {
  return [InfoNormalTableViewCellObject objectWithType:InfoNormalTableViewCellObjectTypeMyEtherWalletCom];
}

- (InfoDestructiveTableViewCellObject *) buildResetWalletCellObject {
  return [InfoDestructiveTableViewCellObject objectWithType:InfoDestructiveTableViewCellObjectResetType];
}

- (InfoEmptyTableViewCellObject *) buildEmptyCellObject {
  return [InfoEmptyTableViewCellObject object];
}

@end
