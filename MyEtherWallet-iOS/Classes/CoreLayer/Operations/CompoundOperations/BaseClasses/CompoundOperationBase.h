//
//  CompoundOperationBase.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 20/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

#import "AsyncOperation.h"

#import "CompoundOperationQueueInput.h"
#import "CompoundOperationQueueOutput.h"
#import "ChainableOperationDelegate.h"
#import "ChainableOperation.h"

typedef void(^CompoundOperationResultBlock)(id data, NSError *error);

@interface CompoundOperationBase : AsyncOperation <ChainableOperationDelegate>
@property (assign, nonatomic) NSUInteger maxConcurrentOperationsCount;
@property (nonatomic, copy) CompoundOperationResultBlock resultBlock;
@property (nonatomic, strong) id<CompoundOperationQueueInput> queueInput;
@property (nonatomic, strong) id<CompoundOperationQueueOutput> queueOutput;
- (void) addOperation:(NSOperation <ChainableOperation> *)operation;
@end
