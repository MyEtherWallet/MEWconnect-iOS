//
//  BuyEther10WebViewController.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 3/21/19.
//  Copyright © 2019 MyEtherWallet, Inc. All rights reserved.
//

#import "BuyEther10WebViewController.h"

#import "BuyEtherWebViewOutput.h"

@implementation BuyEther10WebViewController

#pragma mark - LifeCycle

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
    self.showLoadingBar = YES;
    self.showActionButton = NO;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self.output didTriggerViewReadyEvent];
}

#pragma mark - BuyEtherWebViewInput

- (void) setupInitialStateWithRequest:(NSURLRequest *)request {
  self.title = NSLocalizedString(@"Simplex checkout", @"Buy Ether. Navigation title");
  [self.webView loadRequest:request];
}

#pragma mark - IBActions

- (IBAction) doneAction:(__unused id)sender {
  [self.output doneAction];
}

@end
