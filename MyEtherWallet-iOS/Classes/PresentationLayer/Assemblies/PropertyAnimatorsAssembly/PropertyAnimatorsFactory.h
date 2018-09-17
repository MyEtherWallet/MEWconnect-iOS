//
//  PropertyAnimatorsFactory.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 27/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import UIKit;

@protocol PropertyAnimatorsFactory <NSObject>
- (UIViewPropertyAnimator *) mewQuatroPropertyAnimatorWithDuration:(NSNumber *)duration;
@end
