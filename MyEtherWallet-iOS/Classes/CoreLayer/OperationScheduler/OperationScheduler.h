//
//  OperationScheduler.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 20/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@protocol OperationScheduler <NSObject>
- (void) addOperation:(NSOperation *)operation;
- (void) cancelAllOperations;
@end
