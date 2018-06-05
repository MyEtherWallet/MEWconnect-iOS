//
//  ResponseMapper.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 03/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@protocol ResponseMapper <NSObject>
- (id) mapServerResponse:(id)response withMappingContext:(NSDictionary *)context error:(NSError **)error;
@optional
- (id) serializeResponse:(id)response withMappingContext:(NSDictionary *)context error:(NSError **)error;
@end
