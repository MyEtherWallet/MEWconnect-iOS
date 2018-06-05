//
//  StartViewController.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 14/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import UIKit;

#import "StartViewInput.h"

@protocol StartViewOutput;

@interface StartViewController : UIViewController <StartViewInput>

@property (nonatomic, strong) id<StartViewOutput> output;

@end
