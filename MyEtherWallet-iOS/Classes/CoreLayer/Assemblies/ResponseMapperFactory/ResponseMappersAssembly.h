//
//  ResponseMappersAssembly.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 03/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Typhoon;
@import RamblerTyphoonUtils.AssemblyCollector;

#import "ResponseMappersFactory.h"

@interface ResponseMappersAssembly : TyphoonAssembly <ResponseMappersFactory, RamblerInitialAssembly>

@end
