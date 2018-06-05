//
//  ResponseDeserializersAssembly.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 21/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "ResponseDeserializersAssembly.h"

#import "JSONResponseDeserializer.h"

@implementation ResponseDeserializersAssembly

#pragma mark - Option matcher

- (id<ResponseDeserializer>)deserializerWithType:(NSNumber *)type {
  return [TyphoonDefinition withOption:type matcher:^(TyphoonOptionMatcher *matcher) {
    [matcher caseEqual:@(ResponseDeserializationJSONType)
                   use:[self jsonResponseDeserializer]];
  }];
}

#pragma mark - Concrete definitions

- (id<ResponseDeserializer>)jsonResponseDeserializer {
  return [TyphoonDefinition withClass:[JSONResponseDeserializer class]];
}

@end

