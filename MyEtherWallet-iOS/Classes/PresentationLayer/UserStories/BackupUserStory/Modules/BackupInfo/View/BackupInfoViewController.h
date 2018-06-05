//
//  BackupInfoViewController.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 23/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import UIKit;

#import "BackupInfoViewInput.h"

@protocol BackupInfoViewOutput;

@interface BackupInfoViewController : UIViewController <BackupInfoViewInput>

@property (nonatomic, strong) id<BackupInfoViewOutput> output;

@end
