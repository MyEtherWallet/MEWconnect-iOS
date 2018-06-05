//
//  PasswordViewController.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import UIKit;

#import "PasswordViewInput.h"

@protocol PasswordViewOutput;

@interface PasswordViewController : UIViewController <PasswordViewInput>

@property (nonatomic, strong) id<PasswordViewOutput> output;

@end
