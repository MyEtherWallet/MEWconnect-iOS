//
//  WalletUIStringAttributesProvider.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 3/19/19.
//  Copyright © 2019 MyEtherWallet, Inc. All rights reserved.
//

#import "WalletUIStringAttributesProvider.h"
#import "UIColor+Application.h"

@implementation WalletUIStringAttributesProvider

#pragma mark - QRScanner

+ (NSDictionary<NSAttributedStringKey, id> *) qrScannerMediumTitleAttributes {
  UIFont *font = [UIFont systemFontOfSize:20.0 weight:UIFontWeightMedium];
  UIColor *color = [UIColor whiteColor];
  NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
  style.alignment = NSTextAlignmentCenter;
  
  NSDictionary <NSAttributedStringKey, id> *attributes = @{NSFontAttributeName: font,
                                                           NSForegroundColorAttributeName: color,
                                                           NSParagraphStyleAttributeName: style};
  return attributes;
}

+ (NSDictionary<NSAttributedStringKey, id> *) qrScannerBoldTitleAttributes {
  UIFont *font = [UIFont systemFontOfSize:20.0 weight:UIFontWeightBold];
  UIColor *color = [UIColor whiteColor];
  NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
  style.alignment = NSTextAlignmentCenter;
  
  NSDictionary <NSAttributedStringKey, id> *attributes = @{NSFontAttributeName: font,
                                                           NSForegroundColorAttributeName: color,
                                                           NSParagraphStyleAttributeName: style};
  return attributes;
}

+ (NSDictionary<NSAttributedStringKey, id> *) qrScannerRegularDescriptionAttributes {
  UIFont *font = [UIFont systemFontOfSize:17.0];
  UIColor *color = [UIColor whiteColor];
  NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
  style.alignment = NSTextAlignmentCenter;
  style.lineSpacing = 2.0;
  
  NSDictionary <NSAttributedStringKey, id> *attributes = @{NSFontAttributeName: font,
                                                           NSForegroundColorAttributeName: color,
                                                           NSParagraphStyleAttributeName: style};
  return attributes;
}

+ (NSDictionary<NSAttributedStringKey,id> *) qrScannerWarningAttributes {
  UIFont *font = [UIFont systemFontOfSize:15.0];
  UIColor *color = [UIColor whiteColor];
  NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
  style.alignment = NSTextAlignmentCenter;
  style.lineSpacing = 2.0;
  NSNumber *kern = @(-0.11);
  
  NSDictionary <NSAttributedStringKey, id> *attributes = @{NSFontAttributeName: font,
                                                           NSForegroundColorAttributeName: color,
                                                           NSParagraphStyleAttributeName: style,
                                                           NSKernAttributeName: kern};
  return attributes;
}

+ (NSDictionary<NSAttributedStringKey,id> *) qrScannerWarningLinkAttributes {
  UIColor *color = [UIColor whiteColor];
  UIColor *underlineColor = [UIColor whiteColor];
  NSUnderlineStyle underlineStyle = NSUnderlineStyleSingle;
  NSURL *link = [NSURL URLWithString:@"http://dummy.url"];
  
  NSDictionary <NSAttributedStringKey, id> *attributes = @{NSForegroundColorAttributeName: color,
                                                           NSUnderlineColorAttributeName: underlineColor,
                                                           NSUnderlineStyleAttributeName: @(underlineStyle),
                                                           NSLinkAttributeName: link};
  
  return attributes;
}

@end
 
