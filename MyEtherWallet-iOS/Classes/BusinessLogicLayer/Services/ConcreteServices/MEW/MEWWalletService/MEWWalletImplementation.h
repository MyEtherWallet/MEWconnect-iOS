//
//  MEWWalletImplementation.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 29/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "MEWWallet.h"

@class Web3Wrapper;

@interface MEWWalletImplementation : NSObject <MEWWallet>
@property (nonatomic, strong) Web3Wrapper *wrapper;
@end
