//
//  BuyEtherNavigationController.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 03/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import UIKit;

#import "BuyEtherNavigationViewInput.h"

@protocol BuyEtherNavigationViewOutput;

@interface BuyEtherNavigationController : UINavigationController <BuyEtherNavigationViewInput>
@property (nonatomic, strong) id <BuyEtherNavigationViewOutput> output;
@property (nonatomic, strong) id <UIViewControllerTransitioningDelegate> customTransitioningDelegate;
@end
