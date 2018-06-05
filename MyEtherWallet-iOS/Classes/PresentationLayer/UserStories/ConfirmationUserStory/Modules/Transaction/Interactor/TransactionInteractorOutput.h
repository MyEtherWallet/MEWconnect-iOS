//
//  TransactionInteractorOutput.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@class MEWConnectResponse;

@protocol TransactionInteractorOutput <NSObject>
- (void) transactionDidSigned:(MEWConnectResponse *)response;
@end
