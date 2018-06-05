//
//  MEWConnectFacade.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 19/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

#import "MEWConnectServiceTypes.h"

@class MEWConnectResponse;

@protocol MEWConnectFacade <NSObject>
- (BOOL) connectWithData:(NSString *)data;
- (void) disconnect;
- (BOOL) sendMessage:(MEWConnectResponse *)message;
- (MEWConnectStatus) connectionStatus;
@end
