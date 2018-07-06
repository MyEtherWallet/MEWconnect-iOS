//
//  BuyEtherAmountViewController.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 02/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import UIKit;

#import "BuyEtherAmountViewInput.h"

@protocol BuyEtherAmountViewOutput;

@interface BuyEtherAmountViewController : UIViewController <BuyEtherAmountViewInput>
@property (nonatomic, strong) id <BuyEtherAmountViewOutput> output;
@end
