//
//  InfoViewController.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 24/06/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import UIKit;

#import "InfoViewInput.h"

@class InfoDataDisplayManager;

@protocol InfoViewOutput;

@interface InfoViewController : UIViewController <InfoViewInput>
@property (nonatomic, strong) id <InfoViewOutput> output;
@property (nonatomic, strong) id <UIViewControllerTransitioningDelegate> customTransitioningDelegate;
@property (nonatomic, strong) InfoDataDisplayManager *dataDisplayManager;
@end
