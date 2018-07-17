//
//  UIImage+MEWBackground.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 08/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import UIKit;

@interface UIImage (MEWBackground)
+ (instancetype) imageWithSeed:(NSString *)seed size:(CGSize)rSize;
- (instancetype) renderBackgroundWithSeed:(NSString *)seed size:(CGSize)size logo:(BOOL)renderLogo;
//Background cache
+ (instancetype) cachedBackgroundWithSeed:(NSString *)seed size:(CGSize)size logo:(BOOL)renderLogo;
+ (void) cacheImagesWithSeed:(NSString *)seed fullSize:(CGSize)fullSize cardSize:(CGSize)cardSize;
//Sizes
+ (CGSize) cardSize;
+ (CGSize) fullSize;
@end
