//
//  ForgotPasswordViewController.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 27/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import UIKit;

#import "ForgotPasswordViewInput.h"

@protocol ForgotPasswordViewOutput;

@interface ForgotPasswordViewController : UIViewController <ForgotPasswordViewInput>
@property (nonatomic, strong) id<ForgotPasswordViewOutput> output;
@property (nonatomic, strong) id <UIViewControllerTransitioningDelegate> customTransitioningDelegate;
@end
