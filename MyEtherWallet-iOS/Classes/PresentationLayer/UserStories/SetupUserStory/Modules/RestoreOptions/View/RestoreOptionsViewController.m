//
//  RestoreOptionsViewController.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 18/02/2019.
//  Copyright © 2019 MyEtherWallet, Inc.. All rights reserved.
//

#import "RestoreOptionsViewController.h"

#import "RestoreOptionsViewOutput.h"

#import "RestoreOptionsDataDisplayManager.h"

#import "UIScreen+ScreenSizeType.h"

@interface RestoreOptionsViewController () <RestoreOptionsDataDisplayManagerDelegate>
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIButton *otherOptionsButton;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *titleTopOffsetConstraint;
@end

@implementation RestoreOptionsViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self.output didTriggerViewReadyEvent];
}

#pragma mark - RestoreOptionsViewInput

- (void) setupInitialState {
  switch ([UIScreen mainScreen].screenSizeType) {
    case ScreenSizeTypeInches35:
    case ScreenSizeTypeInches40:
    case ScreenSizeTypeInches47: {
      self.titleTopOffsetConstraint.constant = 24.0;
      break;
    }
    default:
      break;
  }
  
  { //Title label
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 0.0;
    UIFont *font = self.titleLabel.font;
    if ([UIScreen mainScreen].screenSizeType == ScreenSizeTypeInches40) {
      font = [font fontWithSize:36.0];
      style.maximumLineHeight = 36.0;
      style.minimumLineHeight = 36.0;
    } else {
      style.maximumLineHeight = 40.0;
      style.minimumLineHeight = 40.0;
    }
    NSDictionary *attributes = @{NSFontAttributeName: font,
                                 NSForegroundColorAttributeName: self.titleLabel.textColor,
                                 NSParagraphStyleAttributeName: style,
                                 NSKernAttributeName: @(-0.3)};
    self.titleLabel.attributedText = [[NSAttributedString alloc] initWithString:self.titleLabel.text attributes:attributes];
  }
  [self.dataDisplayManager updateDataDisplayManager];
  self.tableView.dataSource = [self.dataDisplayManager dataSourceForTableView:self.tableView];
  self.tableView.delegate = [self.dataDisplayManager delegateForTableView:self.tableView
                                                         withBaseDelegate:self.dataDisplayManager];
}

#pragma mark - IBActions

- (IBAction) closeAction:(__unused id)sender {
  [self.output closeAction];
}

- (IBAction) otherOptionsAction:(__unused id)sender {
  [self.output otherOptionsAction];
}

#pragma mark - RestoreOptionsDataDisplayManagerDelegate

- (void) didTapRecoveryPhrase {
  [self.output recoveryPhraseAction];
}

@end
