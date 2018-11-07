//
//  FindFirstResponderProtocol.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 07/11/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import UIKit;

NS_ASSUME_NONNULL_BEGIN

@protocol FindFirstResponderProtocol <NSObject>
- (nullable UIResponder *) providedFirstResponder;
@end

NS_ASSUME_NONNULL_END
