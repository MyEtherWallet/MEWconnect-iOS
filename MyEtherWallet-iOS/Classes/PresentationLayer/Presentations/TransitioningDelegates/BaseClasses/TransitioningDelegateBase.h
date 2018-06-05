//
//  TransitioningDelegateBase.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 26/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import UIKit;

@protocol PresentationControllerFactory;

@interface TransitioningDelegateBase : NSObject <UIViewControllerTransitioningDelegate>
@property (nonatomic, strong) NSNumber *presentationControllerType;
@property (nonatomic, strong) id <UIViewControllerAnimatedTransitioning> presentingAnimationController;
@property (nonatomic, strong) id <UIViewControllerAnimatedTransitioning> dismissingAnimationController;
@property (nonatomic, strong) id <PresentationControllerFactory> presentationControllerFactory;
@property (nonatomic) CGFloat cornerRadius;
@end
