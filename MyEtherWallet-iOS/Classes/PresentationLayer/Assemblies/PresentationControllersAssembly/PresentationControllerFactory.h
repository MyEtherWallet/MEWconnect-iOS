//
//  PresentationControllerFactory.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 26/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;
#import "PresentationControllerType.h"

@protocol PresentationControllerFactory <NSObject>
- (UIPresentationController *)controllerForPresentationType:(NSNumber *)type
                                    presentedViewController:(UIViewController *)presented
                                   presentingViewController:(UIViewController *)presenting
                                       sourceViewController:(UIViewController *)source
                                               cornerRadius:(NSNumber *)cornerRadius;
@end
