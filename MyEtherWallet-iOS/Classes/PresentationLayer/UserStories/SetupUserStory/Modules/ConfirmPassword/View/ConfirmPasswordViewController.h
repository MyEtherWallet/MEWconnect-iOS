//
//  ConfirmPasswordViewController.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 01/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import UIKit;

#import "ConfirmPasswordViewInput.h"

@protocol ConfirmPasswordViewOutput;

@interface ConfirmPasswordViewController : UIViewController <ConfirmPasswordViewInput>

@property (nonatomic, strong) id<ConfirmPasswordViewOutput> output;

@end
