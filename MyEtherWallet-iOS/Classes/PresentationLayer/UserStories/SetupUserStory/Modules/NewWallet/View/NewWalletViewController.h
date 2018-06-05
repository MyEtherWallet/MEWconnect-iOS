//
//  NewWalletViewController.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import UIKit;

#import "NewWalletViewInput.h"

@protocol NewWalletViewOutput;

@interface NewWalletViewController : UIViewController <NewWalletViewInput>

@property (nonatomic, strong) id<NewWalletViewOutput> output;

@end
