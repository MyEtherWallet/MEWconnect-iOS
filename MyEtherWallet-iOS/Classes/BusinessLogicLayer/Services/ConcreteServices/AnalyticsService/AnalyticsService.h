//
//  AnalyticsService.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 3/10/20.
//  Copyright © 2020 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@protocol AnalyticsService <NSObject>
- (void) trackBannerShown;
- (void) trackBannerClicked;
@end
