//
//  NSCharacterSet+WNS.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 25/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

/* Whitespace, newline, space */
@interface NSCharacterSet (WNS)
+ (NSCharacterSet *) whitespaceAndSpaceAndNewlineCharacterSet;
@end
