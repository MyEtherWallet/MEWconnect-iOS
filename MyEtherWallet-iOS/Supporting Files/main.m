//
//  main.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 14/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import RamblerAppDelegateProxy.RamblerAppDelegateProxy;
@import UIKit;

#import "TyphoonAppDelegate.h"

int main(int argc, char * argv[]) {
  @autoreleasepool {
    [[RamblerAppDelegateProxy injector] setDefaultAppDelegate:[TyphoonAppDelegate new]];
    return UIApplicationMain(argc, argv, nil, NSStringFromClass([RamblerAppDelegateProxy class]));
  }
}
