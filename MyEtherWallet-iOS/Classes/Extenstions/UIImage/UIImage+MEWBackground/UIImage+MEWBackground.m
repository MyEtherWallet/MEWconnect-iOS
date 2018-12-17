//
//  UIImage+MEWBackground.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 08/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "UIImage+MEWBackground.h"
#if BETA
#import "MyEtherWallet_iOS_Beta-Swift.h"
#else
#import "MyEtherWallet_iOS-Swift.h"
#endif
#import "CardView.h"

#import "UIScreen+ScreenSizeType.h"

static CGFloat kMEWBackgroundEtherLogoXOffset = 16.0;
static CGFloat kMEWBackgroundEtherLogoYOffset = 16.0;

@implementation UIImage (MEWBackground)

#pragma mark - Public

+ (instancetype) imageWithSeed:(NSString *)seed size:(CGSize)rSize {
  seed = [seed lowercaseString];
  NSMutableArray *paths = [[NSMutableArray alloc] init];
  
  //Prepare base path
  UIBezierPath *bezierPath = [UIBezierPath bezierPath];
  {
    [bezierPath moveToPoint:CGPointMake(32.0, 69.0)];
    [bezierPath addCurveToPoint:CGPointMake(82.0, 42.0) controlPoint1:CGPointMake(57.606125, 68.999359) controlPoint2:CGPointMake(82.0, 69.501244)];
    [bezierPath addCurveToPoint:CGPointMake(42.0, 3.0)  controlPoint1:CGPointMake(82.0, 15.297916) controlPoint2:CGPointMake(64.606064, 10.780972)];
    [bezierPath addCurveToPoint:CGPointMake(0.0, 29.0) controlPoint1:CGPointMake(18.884848, -4.275507) controlPoint2:CGPointMake(0.0, 7.730424)];
    [bezierPath addCurveToPoint:CGPointMake(32.0, 69.0) controlPoint1:CGPointMake(0.0, 50.970837) controlPoint2:CGPointMake(6.005995, 68.999359)];
    [bezierPath closePath];
  }
  
  [paths addObject:bezierPath];
  
  CGRect bounds;
  
  static short sizeIdx = 29; // to find bounds
  static short totalPaths = 36; //to fill left space
  
  for (short i = 0; i < totalPaths; ++i) {
    bezierPath = [bezierPath copy];
    CGAffineTransform transform = CGAffineTransformMakeScale(1.101f, 1.101f);
    transform = CGAffineTransformRotate(transform, M_PI / 180.0 * 4.0);
    [bezierPath applyTransform:transform];
    [paths insertObject:bezierPath atIndex:0];
    if (i == sizeIdx) {
      bounds = [bezierPath bounds];
    }
  }
  
  //Colors from seed
  NSArray *colors = [UIColor colorWithSeed:seed];
  NSArray *fillColors = nil;
  if ([colors count] == 3) {
    fillColors = [colors arrayByAddingObject:colors[1]];
  } else {
    fillColors = colors;
  }
  
  UIGraphicsBeginImageContextWithOptions(bounds.size, NO, 0.0);
  { //Render pattern
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(context);
    
    for (NSInteger i = 0; i < [paths count]; ++i) {
      UIColor *color = fillColors[i % [fillColors count]];
      [color setFill];
      
      UIBezierPath *path = paths[i];
      
      CGRect pathBounds = [path bounds];
      
      //Move path to the center of pattern
      CGAffineTransform transform = CGAffineTransformMakeTranslation(CGRectGetWidth(bounds) / 2.0 - CGRectGetMidX(pathBounds),
                                                                     CGRectGetHeight(bounds) / 2.0 - CGRectGetMidY(pathBounds));
      [path applyTransform:transform];
      [path fillWithBlendMode:kCGBlendModeNormal alpha:1.0];
    }
    
    UIGraphicsPopContext();
  }
  UIImage *output = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  //Get part of the pattern
  output = [output partWithSeed:seed size:CGSizeMake(rSize.width, rSize.height)];
  return output;
}

- (instancetype) renderBackgroundWithSeed:(NSString *)seed size:(CGSize)size logo:(BOOL)renderLogo {
  seed = [seed lowercaseString];
  UIImage *output = [[self class] _cachedImageWithSeed:seed size:size logo:renderLogo];
  if (!output) {
    UIImage *ethereumLogo = nil;
    if ([UIScreen mainScreen].screenSizeType == ScreenSizeTypeInches40) {
      ethereumLogo = [UIImage imageNamed:@"ethereum_logo_small"];
    } else {
      ethereumLogo = [UIImage imageNamed:@"ethereum_logo"];
    }
    UIImage *shades = [UIImage imageNamed:@"card_shades"];
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(context);
    
    //draw background
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake((size.width - self.size.width) / 2.0,
                             (size.height - self.size.height) / 2.0,
                             self.size.width, self.size.height);
    [self _drawImage:self inRect:rect inContext:context];
    
    if (shades) { //draw shades
      [self _drawImage:shades inRect:rect inContext:context];
    }
    
    if (renderLogo) {
      //draw logo
      CGContextSetBlendMode(context, kCGBlendModeLuminosity);
      rect = CGRectMake(size.width - kMEWBackgroundEtherLogoXOffset - ethereumLogo.size.width,
                        kMEWBackgroundEtherLogoYOffset,
                        ethereumLogo.size.width,
                        ethereumLogo.size.height);
      [self _drawImage:ethereumLogo inRect:rect inContext:context];
    }
    
    UIGraphicsPopContext();
    
    output = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [output _cacheImageWithSeed:seed size:size logo:renderLogo];
  }
  return output;
}

+ (instancetype) cachedBackgroundWithSeed:(NSString *)seed size:(CGSize)size logo:(BOOL)renderLogo {
  seed = [seed lowercaseString];
  return [[self class] _cachedImageWithSeed:seed size:size logo:renderLogo];
}

#pragma mark - Private

//Helper for drawing image
- (void) _drawImage:(UIImage *)image inRect:(CGRect)rect inContext:(CGContextRef)context {
  CGContextTranslateCTM(context, 0, CGRectGetMaxY(rect));
  CGContextScaleCTM(context, 1.0, -1.0);
  
  CGRect drawRect = CGRectMake(CGRectGetMinX(rect), 0.0, CGRectGetWidth(rect), CGRectGetHeight(rect));
  
  CGContextDrawImage(context, drawRect, image.CGImage);
  
  CGContextScaleCTM(context, 1.0, -1.0);
  CGContextTranslateCTM(context, 0, -CGRectGetMaxY(rect));
}

#pragma mark - MEWBackground Cache

+ (void) cacheImagesWithSeed:(NSString *)seed fullSize:(CGSize)fullSize cardSize:(CGSize)cardSize {
  seed = [seed lowercaseString];
  if ([NSThread isMainThread]) {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    dispatch_async(queue, ^{
      [self _cacheImagesWithSeed:seed fullSize:fullSize cardSize:cardSize];
    });
  } else {
    [self _cacheImagesWithSeed:seed fullSize:fullSize cardSize:cardSize];
  }
}

+ (void) _cacheImagesWithSeed:(NSString *)seed fullSize:(CGSize)fullSize cardSize:(CGSize)cardSize {
  UIImage *patternImage = [UIImage imageWithSeed:seed size:fullSize];
  UIImage *backgroundImage = [patternImage renderBackgroundWithSeed:seed size:fullSize logo:NO];
  UIImage *cardImage = [patternImage renderBackgroundWithSeed:seed size:cardSize logo:YES];
  
  [backgroundImage _cacheImageWithSeed:seed size:fullSize logo:NO];
  [cardImage _cacheImageWithSeed:seed size:cardSize logo:YES];
}

+ (instancetype) _cachedImageWithSeed:(NSString *)seed size:(CGSize)size logo:(BOOL)logo {
  NSURL *fileURL = [self _cacheFileURLForSeed:seed size:size logo:logo];
  NSData *data = [NSData dataWithContentsOfURL:fileURL];
  if (data) {
    UIImage *cachedImage = [UIImage imageWithData:data scale:[UIScreen mainScreen].scale];
    return cachedImage;
  }
  return nil;
}

- (void) _cacheImageWithSeed:(NSString *)seed size:(CGSize)size logo:(BOOL)logo {
  NSData *imageData = UIImagePNGRepresentation(self);
  NSError *error = nil;
  NSURL *fileURL = [[self class] _cacheFileURLForSeed:seed size:size logo:logo];
  [imageData writeToURL:fileURL options:NSDataWritingAtomic error:&error];
  DDLogInfo(@"Saved: %@", fileURL);
  if (error) {
    DDLogWarn(@"%@", error);
  }
}

+ (NSURL *) _cacheFileURLForSeed:(NSString *)seed size:(CGSize)size logo:(BOOL)logo {
  NSString *patternName = [NSString stringWithFormat:@"%@_%zd_%zd_%d", seed, (NSInteger)size.width, (NSInteger)size.height, logo];
  NSString *name = [NSString stringWithFormat:@"%@.png", patternName];
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
  NSString *imagePath = [[paths lastObject] stringByAppendingPathComponent:name];
  return [NSURL fileURLWithPath:imagePath];
}

#pragma mark - Class

+ (CGSize) cardSize {
  CGSize fullSize = [self fullSize];
  return CGSizeMake(fullSize.width - kCardViewDefaultOffset * 2.0 - kCardViewDefaultCornerRadius * 2.0, fullSize.height);
}

+ (CGSize) fullSize {
  NSParameterAssert([NSThread isMainThread]);
  CGRect bounds = [UIScreen mainScreen].bounds;
  CGSize fullSize = CGSizeMake(CGRectGetWidth(bounds) + kCardViewDefaultCornerRadius * 2.0, 0.0);
  fullSize.height = floorf((fullSize.width - kCardViewDefaultOffset * 2.0 - kCardViewDefaultCornerRadius * 2.0) * kCardViewAspectRatio);
  return fullSize;
}

@end
