//
//  ToastView.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 3/21/19.
//  Copyright © 2019 MyEtherWallet, Inc. All rights reserved.
//

#import "ToastView.h"

#import "UIColor+Application.h"

static CGSize const ToastViewMinSize = (CGSize){160.0, 160.0};
static NSTimeInterval const ToastViewAutohideDuration = 1.0;

static ToastView *_instance = nil;

@interface ToastView ()
@property (nonatomic, weak) UIView *backgroundView;
@property (nonatomic, weak) UIVisualEffectView *containerView;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UIImageView *iconImageView;
@property (nonatomic, strong) NSTimer *autohideTimer;
@end

@implementation ToastView

#pragma mark - Lifecycle

+ (instancetype) shared {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _instance = [[ToastView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [_instance _prepare];
  });
  return _instance;
}

#pragma mark - Public

- (void) showWithImage:(UIImage *)image title:(NSString *)title {
  if (self.superview == nil) {
    self.titleLabel.text = title;
    self.iconImageView.image = image;
    [self _show];
  }
}

#pragma mark - Private

- (void) _prepare {
  UITapGestureRecognizer *hideGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_hideTapGestureRecognizer:)];
  [self addGestureRecognizer:hideGesture];
  
  UIView *backgroundView = [[UIView alloc] initWithFrame:self.bounds];
  backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
  backgroundView.backgroundColor = [UIColor dimmingBackgroundColor];
  [self addSubview:backgroundView];
  self.backgroundView = backgroundView;
  
  UIBlurEffectStyle style = UIBlurEffectStyleLight;
  if (@available(iOS 11.0, *)) {
    style = UIBlurEffectStyleProminent;
  }
  
  UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:style];
  UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
  blurEffectView.translatesAutoresizingMaskIntoConstraints = NO;
  blurEffectView.layer.cornerRadius = 16.0;
  blurEffectView.layer.masksToBounds = YES;
  [self addSubview:blurEffectView];
  self.containerView = blurEffectView;
  
  UILabel *label = [[UILabel alloc] init];
  label.translatesAutoresizingMaskIntoConstraints = NO;
  label.textAlignment = NSTextAlignmentCenter;
  label.textColor = [UIColor lightGreyTextColor];
  label.font = [UIFont systemFontOfSize:17.0 weight:UIFontWeightMedium];
  [self.containerView.contentView addSubview:label];
  self.titleLabel = label;
  
  UIImageView *imageView = [[UIImageView alloc] init];
  imageView.tintColor = [UIColor lightGreyTextColor];
  imageView.translatesAutoresizingMaskIntoConstraints = NO;
  [self.containerView.contentView addSubview:imageView];
  self.iconImageView = imageView;
  
  UIView *helperView = [[UIView alloc] init];
  helperView.hidden = YES;
  helperView.translatesAutoresizingMaskIntoConstraints = NO;
  [self.containerView.contentView addSubview:helperView];
  
  [NSLayoutConstraint activateConstraints:@[[self.backgroundView.topAnchor constraintEqualToAnchor:self.topAnchor],
                                            [self.backgroundView.leftAnchor constraintEqualToAnchor:self.leftAnchor],
                                            [self.backgroundView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
                                            [self.backgroundView.rightAnchor constraintEqualToAnchor:self.rightAnchor],
                                            [self.containerView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
                                            [self.containerView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
                                            [self.containerView.widthAnchor constraintGreaterThanOrEqualToConstant:ToastViewMinSize.width],
                                            [self.containerView.heightAnchor constraintGreaterThanOrEqualToConstant:ToastViewMinSize.height],
                                            [self.containerView.widthAnchor constraintEqualToAnchor:self.containerView.heightAnchor],
                                            [self.containerView.contentView.leadingAnchor constraintEqualToAnchor:self.titleLabel.leadingAnchor constant:16.0],
                                            [self.titleLabel.trailingAnchor constraintEqualToAnchor:self.containerView.contentView.trailingAnchor constant:16.0],
                                            [self.titleLabel.centerXAnchor constraintEqualToAnchor:self.containerView.contentView.centerXAnchor],
                                            [self.iconImageView.centerXAnchor constraintEqualToAnchor:self.containerView.contentView.centerXAnchor],
                                            [helperView.widthAnchor constraintEqualToConstant:2.0],
                                            [helperView.heightAnchor constraintEqualToConstant:2.0],
                                            [helperView.centerXAnchor constraintEqualToAnchor:helperView.superview.centerXAnchor],
                                            [helperView.centerYAnchor constraintEqualToAnchor:helperView.superview.centerYAnchor constant:11.0],
                                            [self.iconImageView.bottomAnchor constraintEqualToAnchor:helperView.topAnchor constant:-9.0],
                                            [helperView.bottomAnchor constraintEqualToAnchor:self.titleLabel.topAnchor constant:-9.0]]];
}

- (void) _autohide:(__unused NSTimer *)timer {
  [self _hide];
}

- (void) _hideTapGestureRecognizer:(__unused UITapGestureRecognizer *)tapGesture {
  [self.autohideTimer fire];
}

- (void) _show {
  UIWindow *window = [UIApplication sharedApplication].keyWindow;
  [window addSubview:self];
  [NSLayoutConstraint activateConstraints:@[[self.topAnchor constraintEqualToAnchor:window.topAnchor],
                                            [self.leftAnchor constraintEqualToAnchor:window.leftAnchor],
                                            [self.bottomAnchor constraintEqualToAnchor:window.bottomAnchor],
                                            [self.rightAnchor constraintEqualToAnchor:window.rightAnchor]]];
  [self layoutIfNeeded];
  
  self.backgroundView.alpha = 0.0;
  self.containerView.alpha = 0.0;
  [UIView animateWithDuration:0.2
                        delay:0.0
                      options:UIViewAnimationOptionCurveEaseOut
                   animations:^{
                     self.backgroundView.alpha = 1.0;
                   } completion:nil];
  self.containerView.transform = CGAffineTransformMakeScale(1.08, 1.08);
  [UIView animateWithDuration:0.2
                        delay:0.1
                      options:UIViewAnimationOptionCurveEaseOut
                   animations:^{
                     self.containerView.transform = CGAffineTransformIdentity;
                     self.containerView.alpha = 1.0;
                   } completion:nil];
  [self.autohideTimer invalidate];
  self.autohideTimer = [NSTimer timerWithTimeInterval:ToastViewAutohideDuration
                                               target:self
                                             selector:@selector(_autohide:)
                                             userInfo:nil
                                              repeats:NO];
  [[NSRunLoop mainRunLoop] addTimer:self.autohideTimer forMode:NSRunLoopCommonModes];
}

- (void) _hide {
  [self.autohideTimer invalidate];
  [UIView animateWithDuration:0.2
                        delay:0.0
                      options:UIViewAnimationOptionCurveEaseOut
                   animations:^{
                     self.containerView.transform = CGAffineTransformMakeScale(0.92, 0.92);
                     self.containerView.alpha = 0.0;
                   } completion:nil];
  [UIView animateWithDuration:0.2
                        delay:0.1
                      options:UIViewAnimationOptionCurveEaseOut
                   animations:^{
                     self.backgroundView.alpha = 0.0;
                   } completion:^(__unused BOOL finished) {
                     [self removeFromSuperview];
                   }];
}

@end
