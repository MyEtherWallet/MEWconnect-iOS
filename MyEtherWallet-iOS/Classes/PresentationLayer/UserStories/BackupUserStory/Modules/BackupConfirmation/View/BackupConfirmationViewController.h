//
//  BackupConfirmationViewController.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 23/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import UIKit;

#import "BackupConfirmationViewInput.h"

@protocol BackupConfirmationViewOutput;

@interface BackupConfirmationViewController : UIViewController <BackupConfirmationViewInput>

@property (nonatomic, strong) id<BackupConfirmationViewOutput> output;

@end
