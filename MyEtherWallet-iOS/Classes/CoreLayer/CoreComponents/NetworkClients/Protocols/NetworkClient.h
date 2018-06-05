//
//  NetworkClient.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 21/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

static NSString *const NetworkClientErrorDomain = @"com.myetherwallet.mewconnect.networkclient.error-domain";

@class ServerResponseModel;

typedef void(^NetworkClientCompletionBlock)(ServerResponseModel *respodeModel, NSError *error);

@protocol NetworkClient <NSObject>
- (void)sendRequest:(NSURLRequest *)request completionBlock:(NetworkClientCompletionBlock)block;
@end
