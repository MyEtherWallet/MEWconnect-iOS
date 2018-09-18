//
//  RateService.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 18/09/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

@protocol RateService <NSObject>
- (void) transactionSigned;
- (void) clearCount;
- (void) requestReviewIfNeeded;
@end

NS_ASSUME_NONNULL_END
