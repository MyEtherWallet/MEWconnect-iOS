//
//  PonsomizerAssembly.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 22/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "PonsomizerAssembly.h"
#import "PonsomizerImplementation.h"

@implementation PonsomizerAssembly

- (id <Ponsomizer>)ponsomizer {
  return [TyphoonDefinition withClass:[PonsomizerImplementation class]];
}

@end
