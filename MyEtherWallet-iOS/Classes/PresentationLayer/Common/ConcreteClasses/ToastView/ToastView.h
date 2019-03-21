//
//  ToastView.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 3/21/19.
//  Copyright © 2019 MyEtherWallet, Inc. All rights reserved.
//

@import UIKit;

@interface ToastView : UIView
+ (instancetype) shared;
- (void) showWithImage:(UIImage *)image title:(NSString *)title;
@end
