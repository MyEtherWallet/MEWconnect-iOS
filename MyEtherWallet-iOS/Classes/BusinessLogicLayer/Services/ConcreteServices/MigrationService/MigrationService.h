//
//  MigrationService.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 23/10/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

@protocol MigrationService <NSObject>
- (BOOL) isMigrationNeeded;
- (BOOL) isMigrationNeededForKeychain;
- (BOOL) migrate:(NSError **)error;
- (BOOL) migratekeychain:(NSError **)error;
@end

NS_ASSUME_NONNULL_END
