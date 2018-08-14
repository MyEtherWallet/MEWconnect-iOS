//
//  ConfirmationNavigationViewController.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 17/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import UIKit;

#import "ConfirmationNavigationViewInput.h"

@protocol ConfirmationNavigationViewOutput;

@interface ConfirmationNavigationViewController : UINavigationController <ConfirmationNavigationViewInput>
@property (nonatomic, strong) id <ConfirmationNavigationViewOutput> output;
@property (nonatomic, strong) id <UIViewControllerTransitioningDelegate> customTransitioningDelegate;
@end
