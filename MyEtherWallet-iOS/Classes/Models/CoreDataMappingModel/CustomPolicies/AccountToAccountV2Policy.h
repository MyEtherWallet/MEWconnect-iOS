//
//  AccountToAccountV2Policy.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 27/10/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import CoreData;

NS_ASSUME_NONNULL_BEGIN

@interface AccountToAccountV2Policy : NSEntityMigrationPolicy
- (NSString *) UUID;
@end

NS_ASSUME_NONNULL_END
