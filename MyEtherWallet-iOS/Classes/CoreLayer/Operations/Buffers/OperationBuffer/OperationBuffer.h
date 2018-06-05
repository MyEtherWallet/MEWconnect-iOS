//
//  OperationBuffer.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 20/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

#import "ChainableOperationInput.h"
#import "ChainableOperationOutput.h"
#import "CompoundOperationQueueInput.h"
#import "CompoundOperationQueueOutput.h"

@interface OperationBuffer : NSObject <ChainableOperationInput, ChainableOperationOutput, CompoundOperationQueueInput, CompoundOperationQueueOutput>
+ (instancetype)buffer;
@end
