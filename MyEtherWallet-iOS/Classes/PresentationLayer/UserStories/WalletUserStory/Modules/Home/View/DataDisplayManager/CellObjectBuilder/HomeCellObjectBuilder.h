//
//  HomeCellObjectBuilder.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 22/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@class HomeTableViewCellObject;
@class HomeEmptyTableViewCellObject;
@class TokenPlainObject;

@interface HomeCellObjectBuilder : NSObject
- (HomeTableViewCellObject *) buildCellObjectForToken:(TokenPlainObject *)token;
- (NSArray <HomeTableViewCellObject *> *) buildCellObjectsForTokens:(NSArray <TokenPlainObject *> *)tokens;
- (HomeEmptyTableViewCellObject *) buildEmptyCellObject;
@end
