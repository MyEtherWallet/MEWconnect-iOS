//
//  BuyEtherWebViewController.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 05/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import DZNWebViewController;

#import "BuyEtherWebViewInput.h"

@protocol BuyEtherWebViewOutput;

@interface BuyEtherWebViewController : DZNWebViewController <BuyEtherWebViewInput>

@property (nonatomic, strong) id<BuyEtherWebViewOutput> output;

@end
