//
//  ResponseDeserializer.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 21/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

typedef void (^ResponseDeserializerCompletionBlock)(NSDictionary *response, NSError *error);

@protocol ResponseDeserializer <NSObject>
- (void)deserializeServerResponse:(NSData *)responseData completionBlock:(ResponseDeserializerCompletionBlock)block;
@end
