//
//  TransitioningDelegateFactory.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 26/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

#import "TransitioningDelegateType.h"

@protocol UIViewControllerTransitioningDelegate;

@protocol TransitioningDelegateFactory <NSObject>
- (id <UIViewControllerTransitioningDelegate>) transitioningDelegateWithType:(NSNumber *)type cornerRadius:(NSNumber *)cornerRadius;
@end
