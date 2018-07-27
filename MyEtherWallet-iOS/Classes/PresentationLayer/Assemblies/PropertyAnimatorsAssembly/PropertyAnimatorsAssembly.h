//
//  PropertyAnimatorsAssembly.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 27/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Typhoon;
@import RamblerTyphoonUtils.AssemblyCollector;

#import "PropertyAnimatorsFactory.h"

@interface PropertyAnimatorsAssembly : TyphoonAssembly <RamblerInitialAssembly, PropertyAnimatorsFactory>
@end
