//
//  NavigationControllerFactory.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 15/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@class UINavigationController;

@protocol NavigationControllerFactory <NSObject>
- (UINavigationController *) obtainPreconfiguredNavigationController;
- (UINavigationController *) obtainPreconfiguredAuthorizedNavigationController;
@end
