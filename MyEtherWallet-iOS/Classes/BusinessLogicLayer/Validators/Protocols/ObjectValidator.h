//
//  ObjectValidator.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 08/11/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

@protocol ObjectValidator <NSObject>
- (BOOL) isObjectValidated:(id)object;
- (nullable id) extractValidObject:(id)object;
@end

NS_ASSUME_NONNULL_END
