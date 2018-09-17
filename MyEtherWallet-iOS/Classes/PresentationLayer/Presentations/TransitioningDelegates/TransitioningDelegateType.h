//
//  TransitioningDelegateType.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 26/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#ifndef TransitioningDelegateType_h
#define TransitioningDelegateType_h

typedef NS_ENUM(NSUInteger, TransitioningDelegateType) {
  TransitioningDelegateDefaultType              = 0,
  TransitioningDelegateBottomModal              = 1,
  TransitioningDelegateBottomBackgroundedModal  = 2,
  TransitioningDelegateFadeModal                = 3,
};

#endif /* TransitioningDelegateType_h */
