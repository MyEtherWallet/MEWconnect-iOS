//
//  PropertyAnimatorsAssembly.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 27/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "PropertyAnimatorsAssembly.h"

@implementation PropertyAnimatorsAssembly

- (UIViewPropertyAnimator *) mewQuatroPropertyAnimatorWithDuration:(NSNumber *)duration {
  return [TyphoonDefinition withClass:[UIViewPropertyAnimator class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition useInitializer:@selector(initWithDuration:timingParameters:)
                                          parameters:^(TyphoonMethod *initializer) {
                                            [initializer injectParameterWith:duration];
                                            [initializer injectParameterWith:[self mewQuatroCubitTimingParameters]];
                                          }];
                        }];
}

- (UICubicTimingParameters *) mewQuatroCubitTimingParameters {
  //Control points: (0.25, 0.1), (0.25, 1)
  return [TyphoonDefinition withClass:[UICubicTimingParameters class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition useInitializer:@selector(initWithControlPoint1:controlPoint2:)
                                          parameters:^(TyphoonMethod *initializer) {
                                            [initializer injectParameterWith:[NSValue valueWithCGPoint:CGPointMake(0.25, 0.1)]];
                                            [initializer injectParameterWith:[NSValue valueWithCGPoint:CGPointMake(0.25, 1.0)]];
                                          }];
                        }];
}

@end
