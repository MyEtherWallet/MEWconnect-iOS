//
//  ConfirmedTransactionViewController.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 19/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import UIKit;

#import "ConfirmedTransactionViewInput.h"

@protocol ConfirmedTransactionViewOutput;

@interface ConfirmedTransactionViewController : UIViewController <ConfirmedTransactionViewInput>

@property (nonatomic, strong) id<ConfirmedTransactionViewOutput> output;

@end
