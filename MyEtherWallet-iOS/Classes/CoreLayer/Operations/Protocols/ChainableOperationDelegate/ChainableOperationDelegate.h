//
//  ChainableOperationDelegate.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 20/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@protocol ChainableOperationDelegate <NSObject>
- (void)didCompleteChainableOperationWithError:(NSError *)error;
@end
