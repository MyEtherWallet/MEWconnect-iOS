//
//  QRScannerStatusView.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 3/19/19.
//  Copyright © 2019 MyEtherWallet, Inc. All rights reserved.
//

@import MessageUI;

#import "QRScannerStatusView.h"
#import "FlatButton.h"
#import "LinkedLabel.h"
#import "InlineButton.h"

#import "WalletUIStringAttributesProvider.h"
#import "WalletUIStringList.h"
#import "WalletImageCatalog.h"

@interface QRScannerStatusView ()
- (void) _updateType:(QRScannerStatusViewType)type;
@end

@implementation QRScannerStatusView

+ (instancetype) statusViewWithType:(QRScannerStatusViewType)type {
  QRScannerStatusView *view = [[[self class] alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 320.0)];
  view.translatesAutoresizingMaskIntoConstraints = NO;
  [view _updateType:type];
  return view;
}

#pragma mark - Private

- (void) _updateType:(QRScannerStatusViewType)type {
  _type = type;
  NSDictionary *views = nil;
  NSDictionary *metrics = nil;
  NSString *format = nil;
  switch (type) {
    case QRScannerStatusViewConnected: {
      UIImageView *icon = [self _prepareImageViewWithType:type];
      UILabel *title = [self _prepareTitleWithType:type];
      UILabel *description = [self _prepareDescriptionWithType:type];
      
      [self addSubview:icon];
      [self addSubview:title];
      [self addSubview:description];
      
      [NSLayoutConstraint activateConstraints:@[[icon.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
                                                [title.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
                                                [title.leadingAnchor constraintGreaterThanOrEqualToAnchor:self.leadingAnchor],
                                                [title.trailingAnchor constraintLessThanOrEqualToAnchor:self.trailingAnchor],
                                                [description.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
                                                [description.trailingAnchor constraintEqualToAnchor:self.trailingAnchor]]];
      
      views = @{@"icon": icon,
                @"title": title,
                @"description": description};
      metrics = @{@"V_ICON_TO_TITLE": @22.0,
                  @"V_TITLE_TO_DESCRIPTION": @9.0};
      format = @"V:|[icon]-(V_ICON_TO_TITLE)-[title]-(V_TITLE_TO_DESCRIPTION)-[description]|";
      break;
    }
    case QRScannerStatusViewFailure: {
      UIImageView *icon = [self _prepareImageViewWithType:type];
      UILabel *title = [self _prepareTitleWithType:type];
      UIButton *actionButton = [self _prepareActionButtonWithType:type];
      
      [self addSubview:icon];
      [self addSubview:title];
      [self addSubview:actionButton];
      
      [NSLayoutConstraint activateConstraints:@[[icon.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
                                                [title.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
                                                [title.leadingAnchor constraintGreaterThanOrEqualToAnchor:self.leadingAnchor],
                                                [title.trailingAnchor constraintLessThanOrEqualToAnchor:self.trailingAnchor],
                                                [actionButton.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
                                                [actionButton.leadingAnchor constraintGreaterThanOrEqualToAnchor:self.leadingAnchor],
                                                [actionButton.trailingAnchor constraintLessThanOrEqualToAnchor:self.trailingAnchor]]];
      
      UIButton *supportButton = [self _prepareSupportButtonWithType:type];
      if (supportButton) {
        [self addSubview:supportButton];
        
        [NSLayoutConstraint activateConstraints:@[[supportButton.centerXAnchor constraintEqualToAnchor:self.centerXAnchor constant:3.0],
                                                  [supportButton.leadingAnchor constraintGreaterThanOrEqualToAnchor:self.leadingAnchor],
                                                  [supportButton.trailingAnchor constraintLessThanOrEqualToAnchor:self.trailingAnchor]]];
        
        views = @{@"icon": icon,
                  @"title": title,
                  @"action": actionButton,
                  @"support": supportButton};
        metrics = @{@"V_ICON_TO_TITLE": @22.0,
                    @"V_TITLE_TO_ACTION": @16.0,
                    @"V_ACTION_TO_SUPPORT": @16.0};
        format = @"V:|[icon]-(V_ICON_TO_TITLE)-[title]-(V_TITLE_TO_ACTION)-[action]-(V_ACTION_TO_SUPPORT)-[support]|";
      } else {
        views = @{@"icon": icon,
                  @"title": title,
                  @"action": actionButton};
        metrics = @{@"V_ICON_TO_TITLE": @22.0,
                    @"V_TITLE_TO_ACTION": @16.0};
        format = @"V:|[icon]-(V_ICON_TO_TITLE)-[title]-(V_TITLE_TO_ACTION)-[action]|";
      }
      
      _tryAgainButton = actionButton;
      _contactSupportButton = supportButton;
      break;
    }
    case QRScannerStatusViewInProgress: {
      UIActivityIndicatorView *activity = [self _prepareActivityWithType:type];
      UILabel *title = [self _prepareTitleWithType:type];
      
      [self addSubview:activity];
      [self addSubview:title];
      
      [NSLayoutConstraint activateConstraints:@[[activity.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
                                                [title.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
                                                [title.leadingAnchor constraintGreaterThanOrEqualToAnchor:self.leadingAnchor],
                                                [title.trailingAnchor constraintLessThanOrEqualToAnchor:self.trailingAnchor]]];
      
      views = @{@"activity": activity,
                @"title": title};
      metrics = @{@"V_ACTIVITY_TO_TITLE": @15.0};
      format = @"V:|[activity]-(V_ACTIVITY_TO_TITLE)-[title]|";
      
      _activityIndicator = activity;
      break;
    }
    case QRScannerStatusViewNoAccess: {
      LinkedLabel *linkedLabel = [self _prepareSettingsLabelWithType:type];
      
      [self addSubview:linkedLabel];
      
      [NSLayoutConstraint activateConstraints:@[[linkedLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
                                                [linkedLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor]]];
      
      views = @{@"label": linkedLabel};
      metrics = @{};
      format = @"V:|[label]|";
      _settingsLinkedLabel = linkedLabel;
      break;
    }
    case QRScannerStatusViewNoConnection: {
      UILabel *title = [self _prepareTitleWithType:type];
      
      [self addSubview:title];
      
      [NSLayoutConstraint activateConstraints:@[[title.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
                                                [title.leadingAnchor constraintGreaterThanOrEqualToAnchor:self.leadingAnchor],
                                                [title.trailingAnchor constraintLessThanOrEqualToAnchor:self.trailingAnchor]]];
      
      views = @{@"title": title};
      metrics = @{};
      format = @"V:|[title]|";
      break;
    }
    default:
      break;
  }
  
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:metrics views:views]];
}

#pragma mark Icon

- (UIImageView *) _prepareImageViewWithType:(QRScannerStatusViewType)type {
  UIImage *image = [self _imageForType:type];
  if (!image) {
    return nil;
  }
  UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
  imageView.tintColor = [UIColor whiteColor];
  imageView.translatesAutoresizingMaskIntoConstraints = NO;
  return imageView;
}

- (UIImage *) _imageForType:(__unused QRScannerStatusViewType)type {
  switch (type) {
    case QRScannerStatusViewFailure: {
      return WalletImageCatalog.qrScannerConnectionFailure;
      break;
    }
    case QRScannerStatusViewConnected: {
      return WalletImageCatalog.qrScannerConnectionSuccess;
    }
    default:
      break;
  }
  return nil;
}

#pragma mark Title

- (UILabel *) _prepareTitleWithType:(QRScannerStatusViewType)type {
  NSAttributedString *title = [self _attributedTitleForType:type];
  if (!title) {
    return nil;
  }
  UILabel *label = [[UILabel alloc] init];
  label.attributedText = title;
  label.translatesAutoresizingMaskIntoConstraints = NO;
  label.numberOfLines = 0;
  return label;
}

- (NSAttributedString *) _attributedTitleForType:(__unused QRScannerStatusViewType)type {
  NSString *title = nil;
  NSDictionary *attributes = nil;
  switch (type) {
    case QRScannerStatusViewInProgress: {
      title = WalletUIStringList.qrScannerInProgressTitle;
      attributes = WalletUIStringAttributesProvider.qrScannerMediumTitleAttributes;
      break;
    }
    case QRScannerStatusViewFailure: {
      title = WalletUIStringList.qrScannerFailureTitle;
      attributes = WalletUIStringAttributesProvider.qrScannerBoldTitleAttributes;
      break;
    }
    case QRScannerStatusViewConnected: {
      title = WalletUIStringList.qrScannerSuccessTitle;
      attributes = WalletUIStringAttributesProvider.qrScannerBoldTitleAttributes;
      break;
    }
    case QRScannerStatusViewNoConnection: {
      title = WalletUIStringList.noInternetConnection;
      attributes = WalletUIStringAttributesProvider.qrScannerBoldTitleAttributes;
      break;
    }
      
    default:
      break;
  }
  if (!title) {
    return nil;
  }
  NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attributes];
  return attributedTitle;
}

#pragma mark Description

- (UILabel *) _prepareDescriptionWithType:(QRScannerStatusViewType)type {
  NSAttributedString *title = [self _attributedDescriptionForType:type];
  if (!title) {
    return nil;
  }
  UILabel *label = [[UILabel alloc] init];
  label.alpha = 0.7;
  label.attributedText = title;
  label.translatesAutoresizingMaskIntoConstraints = NO;
  label.numberOfLines = 0;
  return label;
}

- (NSAttributedString *) _attributedDescriptionForType:(__unused QRScannerStatusViewType)type {
  NSString *title = nil;
  NSDictionary *attributes = nil;
  switch (type) {
    case QRScannerStatusViewConnected: {
      title = WalletUIStringList.qrScannerSuccessDescription;
      attributes = WalletUIStringAttributesProvider.qrScannerRegularDescriptionAttributes;
      break;
    }
      
    default:
      break;
  }
  if (!title) {
    return nil;
  }
  NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attributes];
  return attributedTitle;
}

#pragma mark Action

- (UIButton *) _prepareActionButtonWithType:(__unused QRScannerStatusViewType)type {
  FlatButton *flatButton = [FlatButton buttonWithType:UIButtonTypeSystem];
  flatButton.forceCompact = YES;
  flatButton.contentEdgeInsets = UIEdgeInsetsMake(8.0, 18.0, 8.0, 18.0);
  flatButton.theme = FlatButtonThemeLighterBlue;
  [flatButton setTitle:WalletUIStringList.qrScannerTryAgainTitle forState:UIControlStateNormal];
  flatButton.translatesAutoresizingMaskIntoConstraints = NO;
  return flatButton;
}

#pragma mark Support

- (UIButton *) _prepareSupportButtonWithType:(__unused QRScannerStatusViewType)type {
  if (![MFMailComposeViewController canSendMail]) {
    return nil;
  }
  InlineButton *button = [InlineButton buttonWithType:UIButtonTypeSystem];
  button.titleLabel.font = [UIFont systemFontOfSize:17.0];
  [button setTitle:WalletUIStringList.qrScannerContactSupportTitle forState:UIControlStateNormal];
  [button setImage:WalletImageCatalog.sharedInlineShevron forState:UIControlStateNormal];
  [button setTintColor:[UIColor whiteColor]];
  [button setImageEdgeInsets:UIEdgeInsetsMake(1.0, 5.0, 0.0, 0.0)];
  button.alpha = 0.7;
  button.translatesAutoresizingMaskIntoConstraints = NO;
  return button;
}

#pragma mark Activity

- (UIActivityIndicatorView *) _prepareActivityWithType:(__unused QRScannerStatusViewType)type {
  UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
  activity.hidesWhenStopped = YES;
  activity.translatesAutoresizingMaskIntoConstraints = NO;
  return activity;
}

#pragma mark Settings

- (LinkedLabel *) _prepareSettingsLabelWithType:(__unused QRScannerStatusViewType)type {
  NSAttributedString *title = [self _attributedSettingsForType:type];
  if (!title) {
    return nil;
  }
  LinkedLabel *label = [[LinkedLabel alloc] init];
  label.attributedText = title;
  label.translatesAutoresizingMaskIntoConstraints = NO;
  return label;
}

- (NSAttributedString *) _attributedSettingsForType:(QRScannerStatusViewType)type {
  NSString *title = nil;
  NSArray <NSString *> *linkedParts = nil;
  NSDictionary *attributes = nil;
  NSDictionary *linkAttributes = nil;
  switch (type) {
    case QRScannerStatusViewNoAccess: {
      title = WalletUIStringList.qrScannerNoAccessTitle;
      linkedParts = WalletUIStringList.qrScannerNoAccessTitleLinked;
      attributes = WalletUIStringAttributesProvider.qrScannerWarningAttributes;
      linkAttributes = WalletUIStringAttributesProvider.qrScannerWarningLinkAttributes;
      break;
    }
      
    default:
      break;
  }
  if (!title) {
    return nil;
  }
  NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc] initWithString:title attributes:attributes];
  for (NSString *part in linkedParts) {
    NSRange range = [attributedTitle.string rangeOfString:part];
    if (range.location != NSNotFound && range.length > 0) {
      [attributedTitle addAttributes:linkAttributes range:range];
    }
  }
  
  return [attributedTitle copy];
}

@end
