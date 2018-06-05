//
//  BackupStartViewController.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 23/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import UIKit;

#import "BackupStartViewInput.h"

@protocol BackupStartViewOutput;

@interface BackupStartViewController : UIViewController <BackupStartViewInput>

@property (nonatomic, strong) id<BackupStartViewOutput> output;

@end
