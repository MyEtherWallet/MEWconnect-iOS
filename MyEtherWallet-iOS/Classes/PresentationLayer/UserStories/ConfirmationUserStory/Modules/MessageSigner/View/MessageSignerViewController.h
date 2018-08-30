//
//  MessageSignerViewController.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 03/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import UIKit;

#import "MessageSignerViewInput.h"

@protocol MessageSignerViewOutput;

@interface MessageSignerViewController : UIViewController <MessageSignerViewInput>
@property (nonatomic, strong) id<MessageSignerViewOutput> output;
@end
