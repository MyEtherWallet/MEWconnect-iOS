//
//  BackupDoneViewController.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 23/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import UIKit;

#import "BackupDoneViewInput.h"

@protocol BackupDoneViewOutput;

@interface BackupDoneViewController : UIViewController <BackupDoneViewInput>

@property (nonatomic, strong) id<BackupDoneViewOutput> output;

@end
