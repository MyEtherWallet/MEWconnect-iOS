//
//  NSString+RCFCapitalization.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 03/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (RCFCapitalization)
- (NSString *)rcf_decapitalizedStringSavingCase;
@end
