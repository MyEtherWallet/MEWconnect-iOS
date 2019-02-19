//
//  RestoreOptionsCellObjectBuilder.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 2/18/19.
//  Copyright © 2019 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@class RestoreOptionsNormalTableViewCellObject;
@class RestoreOptionsEmptyTableViewCellObject;

NS_ASSUME_NONNULL_BEGIN

@interface RestoreOptionsCellObjectBuilder : NSObject
- (RestoreOptionsNormalTableViewCellObject *) buildRecoveryPhraseCellObjectWithCompactSize:(BOOL)compact;
- (RestoreOptionsEmptyTableViewCellObject *) buildEmptyCellObject;
@end

NS_ASSUME_NONNULL_END
