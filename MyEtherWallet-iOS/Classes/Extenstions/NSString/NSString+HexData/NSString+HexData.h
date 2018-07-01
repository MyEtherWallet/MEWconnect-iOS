//
//  NSString+HexData.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 24/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@interface NSString (HexData)
- (NSData *) parseHexData;
@end
