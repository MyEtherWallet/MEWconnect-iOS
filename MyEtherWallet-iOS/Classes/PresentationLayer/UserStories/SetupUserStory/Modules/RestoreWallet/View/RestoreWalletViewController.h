//
//  RestoreWalletViewController.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import UIKit;

#import "RestoreWalletViewInput.h"

@protocol RestoreWalletViewOutput;

@interface RestoreWalletViewController : UIViewController <RestoreWalletViewInput>

@property (nonatomic, strong) id<RestoreWalletViewOutput> output;

@end
