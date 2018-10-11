//
//  AboutViewController.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 25/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import UIKit;

#import "AboutViewInput.h"

@protocol AboutViewOutput;

@interface AboutViewController : UIViewController <AboutViewInput>

@property (nonatomic, strong) id<AboutViewOutput> output;

@end
