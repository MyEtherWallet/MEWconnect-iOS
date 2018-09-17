//
//  NSAttributedString+CustomEllipses.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 11/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@interface NSAttributedString (CustomEllipsis)
/*
 @truncationPosition - relative position from the end of the string. >= 0
 */
- (instancetype) truncatedAttributedStringWithCustomEllipsis:(NSAttributedString *)ellipsis maxSize:(CGSize)maxSize truncationPosition:(NSInteger)position;
@end
