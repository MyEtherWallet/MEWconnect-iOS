//
//  UIBezierPath+Morphing.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 19/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import UIKit;

@interface UIBezierPath (Morphing)
+ (instancetype) segmentedPathWithSize:(CGSize)size numberOfCorners:(NSUInteger)numberOfCorners numberOfMorphCorners:(NSUInteger)numberOfMorphCorners;
@end
