//
//  TyphoonAppDelegate.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 14/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import RamblerTyphoonUtils.AssemblyCollector;

#import "TyphoonAppDelegate.h"

@implementation TyphoonAppDelegate

- (NSArray *)initialAssemblies {
  RamblerInitialAssemblyCollector *collector = [RamblerInitialAssemblyCollector new];
  return [collector collectInitialAssemblyClasses];
}

@end
