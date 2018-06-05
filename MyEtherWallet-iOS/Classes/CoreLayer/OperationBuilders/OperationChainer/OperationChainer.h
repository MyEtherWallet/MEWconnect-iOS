//
//  OperationChainer.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 20/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@protocol ChainableOperation;
@class OperationBuffer;
@class CompoundOperationBase;

@interface OperationChainer : NSObject
- (void)chainParentOperation:(NSOperation <ChainableOperation> *)parentOperation
          withChildOperation:(NSOperation <ChainableOperation> *)childOperation
                  withBuffer:(OperationBuffer *)buffer;
- (void)chainCompoundOperation:(CompoundOperationBase *)compoundOperation
  withChainableOperationsQueue:(NSArray <NSOperation<ChainableOperation> *> *)chainableOperationsQueue;
@end
