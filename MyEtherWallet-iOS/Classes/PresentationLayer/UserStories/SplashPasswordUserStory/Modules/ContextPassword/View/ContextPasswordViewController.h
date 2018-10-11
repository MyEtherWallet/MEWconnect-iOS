//
//  ContextPasswordViewController.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 11/09/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import UIKit;

#import "ContextPasswordViewInput.h"

@protocol ContextPasswordViewOutput;

@interface ContextPasswordViewController : UIViewController <ContextPasswordViewInput>
@property (nonatomic, strong) id<ContextPasswordViewOutput> output;
@property (nonatomic, strong) id <UIViewControllerTransitioningDelegate> customTransitioningDelegate;
@end
