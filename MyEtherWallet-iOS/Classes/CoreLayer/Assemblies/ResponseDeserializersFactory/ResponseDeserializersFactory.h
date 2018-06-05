//
//  ResponseDeserializersFactory.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 21/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

#import "ResponseDeserializationType.h"

@protocol ResponseDeserializer;

@protocol ResponseDeserializersFactory <NSObject>
- (id<ResponseDeserializer>)deserializerWithType:(NSNumber *)type;
@end
