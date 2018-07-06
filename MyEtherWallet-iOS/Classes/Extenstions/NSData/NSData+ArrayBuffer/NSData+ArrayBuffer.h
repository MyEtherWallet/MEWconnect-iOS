//
//  NSData+ArrayBuffer.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 19/06/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@interface NSData (ArrayBuffer)
- (NSArray <NSNumber *> *) convertToBuffer;
@end
