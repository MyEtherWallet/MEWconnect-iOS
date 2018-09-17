//
//  BuyEtherWebViewInput.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 05/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@protocol BuyEtherWebViewInput <NSObject>

- (void) setupInitialStateWithRequest:(NSURLRequest *)request;

@end
