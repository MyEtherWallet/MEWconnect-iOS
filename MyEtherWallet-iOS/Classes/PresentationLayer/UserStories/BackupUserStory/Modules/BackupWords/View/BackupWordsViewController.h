//
//  BackupWordsViewController.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 23/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import UIKit;

#import "BackupWordsViewInput.h"

@protocol BackupWordsViewOutput;

@interface BackupWordsViewController : UIViewController <BackupWordsViewInput>

@property (nonatomic, strong) id<BackupWordsViewOutput> output;

@end
