//
//  TransactionViewController.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import UIKit;

#import "TransactionViewInput.h"

@protocol TransactionViewOutput;

@interface TransactionViewController : UIViewController <TransactionViewInput>
@property (nonatomic, strong) id <TransactionViewOutput> output;
@end
