//
//  SplashPasswordViewController.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 26/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import UIKit;

#import "SplashPasswordViewInput.h"

@protocol SplashPasswordViewOutput;

@interface SplashPasswordViewController : UIViewController <SplashPasswordViewInput>
@property (nonatomic, strong) id <SplashPasswordViewOutput> output;
@property (nonatomic, strong) id <UIViewControllerTransitioningDelegate> customTransitioningDelegate;
@end
