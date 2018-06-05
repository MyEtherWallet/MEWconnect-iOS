//
//  MEWSearchBar.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 16/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "MEWSearchBar.h"

static CGFloat const kMEWSearchBarHeight = 44.0;

@implementation MEWSearchBar

- (CGSize)intrinsicContentSize {
  CGSize size = [super intrinsicContentSize];
  size.height = kMEWSearchBarHeight;
  return size;
}

@end
