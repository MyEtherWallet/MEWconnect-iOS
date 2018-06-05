//
//  ServerResponseModel.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 21/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@interface ServerResponseModel : NSObject
@property (nonatomic, strong, readonly) NSHTTPURLResponse *response;
@property (nonatomic, strong, readonly) NSData *data;

- (instancetype)initWithResponse:(NSHTTPURLResponse *)response data:(NSData *)data;
@end
