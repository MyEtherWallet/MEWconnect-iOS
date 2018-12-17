//
//  CardView.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 09/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import UIKit;

#import "BlockchainNetworkTypes.h"

@protocol CardViewDelegate;

FOUNDATION_EXPORT CGFloat const kCardViewDefaultShadowOpacity;
FOUNDATION_EXPORT CGFloat const kCardViewDefaultCornerRadius;
FOUNDATION_EXPORT CGFloat const kCardViewDefaultOffset;
FOUNDATION_EXPORT CGFloat const kCardViewAspectRatio;

@interface CardView : UIView
@property (nonatomic, weak) IBOutlet id <CardViewDelegate> delegate;
@property (nonatomic) BOOL backedUp;
@property (nonatomic, strong, readonly) UIImage *backgroundImage;
- (void) updateWithSeed:(NSString *)seed;
- (void) updateBalance:(NSDecimalNumber *)balance network:(BlockchainNetworkType)network;
- (void) updateEthPrice:(NSDecimalNumber *)price;
@end

@protocol CardViewDelegate <NSObject>
- (void) cardViewDidTouchShareButton:(CardView *)cardView;
- (void) cardViewDidTouchBackupButton:(CardView *)cardView;
- (void) cardViewDidTouchBackupStatusButton:(CardView *)cardView;
@end
