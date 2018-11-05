//
//  BuyEtherWebViewController.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 05/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "BuyEtherWebViewController.h"

#import "BuyEtherWebViewOutput.h"

#define BEW_IS_IPAD ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)

@implementation BuyEtherWebViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
	[super viewDidLoad];

	[self.output didTriggerViewReadyEvent];
}

#pragma mark - BuyEtherWebViewInput

- (void) setupInitialStateWithRequest:(NSURLRequest *)request {
  self.supportedWebNavigationTools = DZNWebNavigationToolBackward | DZNWebNavigationToolForward | DZNWebNavigationToolStopReload;
  self.supportedWebActions = DZNWebActionNone;
  self.hideBarsWithGestures = NO;
  self.showLoadingProgress = YES;
  self.webNavigationPrompt = DZNWebNavigationPromptNone;
  self.title = NSLocalizedString(@"Simplex checkout", @"Buy Ether. Navigation title");
  
  [self.webView loadRequest:request];
}

#pragma mark - Override

- (NSArray *) navigationToolItems {
  NSMutableArray *items = [NSMutableArray new];
  
  UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
  UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
  fixedSpace.width = 55.0;
  
  if ((self.supportedWebNavigationTools & DZNWebNavigationToolBackward) > 0 || (self.supportedWebNavigationTools == DZNWebNavigationToolAll)) {
    [items addObject:self.backwardBarItem];
    [items addObject:fixedSpace];
  }
  
  if ((self.supportedWebNavigationTools & DZNWebNavigationToolForward) > 0 || (self.supportedWebNavigationTools == DZNWebNavigationToolAll)) {
    [items addObject:self.forwardBarItem];
  }
  
  if ((self.supportedWebNavigationTools & DZNWebNavigationToolStopReload) > 0 || (self.supportedWebNavigationTools == DZNWebNavigationToolAll)) {
    if (!BEW_IS_IPAD) [items addObject:flexibleSpace];
    [items addObject:self.stateBarItem];
  }
  
  if (self.supportedWebActions > 0) {
    if (!BEW_IS_IPAD) [items addObject:flexibleSpace];
    [items addObject:self.actionBarItem];
  }
  
  return items;
}

#pragma mark - IBActions

- (IBAction) doneAction:(__unused id)sender {
  [self.output doneAction];
}

@end
