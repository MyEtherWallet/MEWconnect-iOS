//
//  SecurityService.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 07/11/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

@protocol SecurityService <NSObject>
- (void) registerResignActive;
- (void) registerBecomeActive;

- (void) enableForceProtection;
- (void) disableForceProtection;
- (BOOL) obtainProtectionStatus;
- (void) resetOneTimeProtection;
@end

NS_ASSUME_NONNULL_END
