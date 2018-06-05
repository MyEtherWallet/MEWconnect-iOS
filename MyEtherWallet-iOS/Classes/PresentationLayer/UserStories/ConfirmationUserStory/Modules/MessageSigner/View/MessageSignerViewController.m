//
//  MessageSignerViewController.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 03/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "MessageSignerViewController.h"

#import "MessageSignerViewOutput.h"

@interface MessageSignerViewController ()
@property (nonatomic, weak) IBOutlet UILabel *messageLabel;
@end

@implementation MessageSignerViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
	[super viewDidLoad];

	[self.output didTriggerViewReadyEvent];
}

#pragma mark - MessageSignerViewInput

- (void) setupInitialState {
}

- (void) updateMessage:(NSString *)message {
  self.messageLabel.text = [NSString stringWithFormat:@"Sign message: %@?", message];
}

#pragma mark - IBAction

- (IBAction)signAction:(id)sender {
  [self.output signAction];
}

- (IBAction)declineAction:(id)sender {
  [self.output declineAction];
}

@end
