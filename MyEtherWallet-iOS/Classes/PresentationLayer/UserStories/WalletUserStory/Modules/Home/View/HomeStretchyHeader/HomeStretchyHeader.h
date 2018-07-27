//
//  HomeStretchyHeader.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 11/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import GSKStretchyHeaderView;

@class CardView;
@class RotationButton;

@protocol HomeStretchyHeaderDelegate;

FOUNDATION_EXPORT NSTimeInterval const kHomeStretchyHeaderFadeDuration;

typedef NS_ENUM(NSInteger, HomeStretchyHeaderSearchBarStyle) {
  HomeStretchyHeaderSearchBarStyleWhite,
  HomeStretchyHeaderSearchBarStyleLightBlue,
};

@interface HomeStretchyHeader : GSKStretchyHeaderView
@property (nonatomic, weak) id <HomeStretchyHeaderDelegate> delegate;
@property (nonatomic, weak, readonly) CardView *cardView;
@property (nonatomic, weak, readonly) UISearchBar *searchBar;
@property (nonatomic, weak, readonly) UIButton *infoButton;
@property (nonatomic, weak, readonly) UIButton *buyEtherButton;
@property (nonatomic, weak, readonly) UIButton *networkButton;
@property (nonatomic, weak, readonly) UILabel *titleBalanceLabel;
@property (nonatomic, weak, readonly) RotationButton *refreshButton;
@property (nonatomic) HomeStretchyHeaderSearchBarStyle searchBarStyle;
- (void) refreshContentIfNeeded;
- (void) updateHeightIfNeeded;
- (void) updateTitle:(NSString *)title;
- (void) updateTokensPrice:(NSDecimalNumber *)price;
- (UIStatusBarStyle) preferredStatusBarStyle;
- (instancetype) initWithFrame:(CGRect)frame delegate:(id <HomeStretchyHeaderDelegate>)delegate;
@end

@protocol HomeStretchyHeaderDelegate <NSObject>
- (void) homeStretchyHeaderRequirinUpdateStatusBarStyle:(HomeStretchyHeader *)strethyHeader;
- (id <UILayoutSupport>) topLayoutGuide;
- (void) homeStretchyHeaderViewDidChangeBackgroundAlpha:(CGFloat)alpha;
@end
