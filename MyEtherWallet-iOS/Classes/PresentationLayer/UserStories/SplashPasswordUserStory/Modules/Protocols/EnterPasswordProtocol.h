//
//  EnterPasswordProtocol.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 11/09/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

@protocol EnterPasswordProtocol <NSObject>
- (void) passwordDidEntered:(NSString *)password;
@end

NS_ASSUME_NONNULL_END
