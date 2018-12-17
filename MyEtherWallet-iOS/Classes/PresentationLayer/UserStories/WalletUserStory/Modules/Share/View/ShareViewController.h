//
//  ShareViewController.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 11/10/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import UIKit;

#import "ShareViewInput.h"

@protocol ShareViewOutput;

@interface ShareViewController : UIViewController <ShareViewInput>
@property (nonatomic, strong) id<ShareViewOutput> output;
@property (nonatomic, strong) id <UIViewControllerTransitioningDelegate> customTransitioningDelegate;
@end
