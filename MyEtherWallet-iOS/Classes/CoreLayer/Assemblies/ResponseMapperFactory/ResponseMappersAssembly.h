//
//  ResponseMappersAssembly.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 03/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Typhoon;

#import "ResponseMappersFactory.h"
#import <RamblerTyphoonUtils/AssemblyCollector.h>

@interface ResponseMappersAssembly : TyphoonAssembly <ResponseMappersFactory, RamblerInitialAssembly>

@end
