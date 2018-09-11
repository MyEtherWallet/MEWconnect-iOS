//
//  MessageSignerInteractorOutput.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 03/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@class MEWConnectResponse;

@protocol MessageSignerInteractorOutput <NSObject>
- (void) messageDidSigned:(MEWConnectResponse *)response;
- (void) messageDidFailure;
@end
