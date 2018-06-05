//
//  CommonNetworkClient.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 21/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

#import "NetworkClient.h"

@interface CommonNetworkClient : NSObject <NetworkClient>
@property (nonatomic, strong, readonly) NSURLSession *session;
- (instancetype)initWithURLSession:(NSURLSession *)session;
@end

