//
//  BuyEtherHistoryViewController.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 02/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import UIKit;

#import "BuyEtherHistoryViewInput.h"

@protocol BuyEtherHistoryViewOutput;

@class BuyEtherHistoryTableViewAnimator;
@class BuyEtherHistoryDataDisplayManager;

@interface BuyEtherHistoryViewController : UITableViewController <BuyEtherHistoryViewInput>

@property (nonatomic, strong) id<BuyEtherHistoryViewOutput> output;
@property (nonatomic, strong) BuyEtherHistoryTableViewAnimator *tableViewAnimator;
@property (nonatomic, strong) BuyEtherHistoryDataDisplayManager *dataDisplayManager;
@end
