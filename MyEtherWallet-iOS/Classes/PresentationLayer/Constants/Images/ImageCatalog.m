//
//  ImageCatalog.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 3/19/19.
//  Copyright © 2019 MyEtherWallet, Inc. All rights reserved.
//

#import "ImageCatalog.h"

typedef NSString *ImageCatalogName NS_TYPED_ENUM;

static ImageCatalogName const kInlineSmallShevron = @"inline_small_chevron";

@implementation ImageCatalog

+ (UIImage *) sharedInlineShevron {
  return [UIImage imageNamed:kInlineSmallShevron];
}

@end
