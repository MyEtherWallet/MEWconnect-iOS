//
//  NavigationControllerFactoryImplementation.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 15/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import UIKit;

#import "NavigationControllerFactory.h"

@interface NavigationControllerFactoryImplementation : NSObject <NavigationControllerFactory>
@property (nonatomic, strong) UIStoryboard *walletStoryboard;
+ (instancetype)factoryWithStoryboard:(UIStoryboard *)storyboard;
@end
