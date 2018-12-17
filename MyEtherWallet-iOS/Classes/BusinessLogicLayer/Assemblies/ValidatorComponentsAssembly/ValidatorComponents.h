//
//  ValidatorComponents.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 08/11/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@protocol ObjectValidator;

NS_ASSUME_NONNULL_BEGIN

@protocol ValidatorComponents <NSObject>
- (id <ObjectValidator>) mnemonicsValidator;
@end

NS_ASSUME_NONNULL_END
