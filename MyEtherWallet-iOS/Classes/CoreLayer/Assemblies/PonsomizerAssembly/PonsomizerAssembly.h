//
//  PonsomizerAssembly.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 22/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Typhoon;
@import RamblerTyphoonUtils.AssemblyCollector;

@protocol Ponsomizer;

@interface PonsomizerAssembly : TyphoonAssembly <RamblerInitialAssembly>
- (id <Ponsomizer>)ponsomizer;
@end

