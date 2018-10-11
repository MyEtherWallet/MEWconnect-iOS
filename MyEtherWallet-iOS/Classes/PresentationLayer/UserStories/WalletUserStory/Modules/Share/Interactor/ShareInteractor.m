//
//  ShareInteractor.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 11/10/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "ShareInteractor.h"

#import "ShareInteractorOutput.h"

#import "AccountPlainObject.h"

static CGFloat const kShareInteractorQRCodeSize = 155.0;

@interface ShareInteractor ()
@property (nonatomic, strong) AccountPlainObject *account;
@property (nonatomic, strong) UIImage *qrCode;
@end

@implementation ShareInteractor

#pragma mark - ShareInteractorInput

- (void) configureWithAccount:(AccountPlainObject *)account {
  self.account = account;
  
  NSString *address = account.publicAddress;
  NSData *addressData = [address dataUsingEncoding:NSUTF8StringEncoding];
  
  CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
  [qrFilter setValue:addressData forKey:@"inputMessage"];
  [qrFilter setValue:@"L" forKey: @"inputCorrectionLevel"];
  
  CIImage *qrImage = qrFilter.outputImage;
  float scaleX = kShareInteractorQRCodeSize / qrImage.extent.size.width;
  float scaleY = kShareInteractorQRCodeSize / qrImage.extent.size.height;
  
  qrImage = [qrImage imageByApplyingTransform:CGAffineTransformMakeScale(scaleX, scaleY)];
  
  self.qrCode = [UIImage imageWithCIImage:qrImage scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
}

- (NSString *) obtainPublicAddress {
  return self.account.publicAddress;
}

- (UIImage *)obtainQRCode {
  return self.qrCode;
}

- (void) copyAddress {
  [UIPasteboard generalPasteboard].string = self.account.publicAddress;
}

- (NSArray *) shareActivityItems {
  return @[self.account.publicAddress];
}

@end
