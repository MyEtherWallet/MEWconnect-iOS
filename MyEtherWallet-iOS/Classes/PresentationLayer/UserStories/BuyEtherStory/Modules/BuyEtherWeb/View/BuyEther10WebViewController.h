//
//  BuyEther10WebViewController.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 3/21/19.
//  Copyright © 2019 MyEtherWallet, Inc. All rights reserved.
//

@import TOWebViewController;

#import "BuyEtherWebViewInput.h"

@protocol BuyEtherWebViewOutput;

@interface BuyEther10WebViewController : TOWebViewController <BuyEtherWebViewInput>

@property (nonatomic, strong) id<BuyEtherWebViewOutput> output;

@end
