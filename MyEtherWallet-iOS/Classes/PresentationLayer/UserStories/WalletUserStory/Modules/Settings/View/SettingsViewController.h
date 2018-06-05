//
//  SettingsViewController.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import UIKit;

#import "SettingsViewInput.h"

@protocol SettingsViewOutput;

@interface SettingsViewController : UIViewController <SettingsViewInput>

@property (nonatomic, strong) id<SettingsViewOutput> output;

@end
