//
//  RestoreOptionsCellObjectBuilder.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 2/18/19.
//  Copyright © 2019 MyEtherWallet, Inc. All rights reserved.
//

#import "RestoreOptionsCellObjectBuilder.h"

#import "RestoreOptionsNormalTableViewCellObject.h"
#import "RestoreOptionsEmptyTableViewCellObject.h"

@implementation RestoreOptionsCellObjectBuilder

- (RestoreOptionsNormalTableViewCellObject *) buildRecoveryPhraseCellObjectWithCompactSize:(BOOL)compact {
  return [RestoreOptionsNormalTableViewCellObject objectWithType:RestoreOptionsNormalTableViewCellObjectTypeRecoveryPhrase compact:compact];
}

- (RestoreOptionsEmptyTableViewCellObject *) buildEmptyCellObject {
  return [RestoreOptionsEmptyTableViewCellObject object];
}

@end
