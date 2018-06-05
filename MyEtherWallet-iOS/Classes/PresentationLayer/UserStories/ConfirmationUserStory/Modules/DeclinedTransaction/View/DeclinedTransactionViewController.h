//
//  DeclinedTransactionViewController.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import UIKit;

#import "DeclinedTransactionViewInput.h"

@protocol DeclinedTransactionViewOutput;

@interface DeclinedTransactionViewController : UIViewController <DeclinedTransactionViewInput>

@property (nonatomic, strong) id<DeclinedTransactionViewOutput> output;

@end
