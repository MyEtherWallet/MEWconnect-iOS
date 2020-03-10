//
//  BannerView.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 3/6/20.
//  Copyright © 2020 MyEtherWallet, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BannerViewActionBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface BannerView : UIView
@property (nonatomic, strong) BannerViewActionBlock actionBlock;
- (void) playAnimation;
- (void) stopAnimation;
@end

NS_ASSUME_NONNULL_END
