//
//  CompoundOperationDebugDescriptionFormatter.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 20/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "CompoundOperationDebugDescriptionFormatter.h"

#import "CompoundOperationBase.h"
#import "OperationBuffer.h"

@implementation CompoundOperationDebugDescriptionFormatter

+ (NSString *)debugDescriptionForCompoundOperation:(CompoundOperationBase *)compoundOperation
                                 withInternalQueue:(NSOperationQueue *)internalQueue {
  NSMutableString *debugDescription = [NSMutableString new];
  
  // General Information
  [debugDescription appendString:@"====================================\n"];
  [debugDescription appendString:@"General Information:\n"];
  [debugDescription appendString:[NSString stringWithFormat:@"- The operation class: %@\n", NSStringFromClass([compoundOperation class])]];
  [debugDescription appendString:[NSString stringWithFormat:@"- The inner operation queue name: %@\n", internalQueue.name]];
  [debugDescription appendString:[NSString stringWithFormat:@"- Count of operations in the inner queue: %li\n", (unsigned long)internalQueue.operationCount]];
  [debugDescription appendString:[NSString stringWithFormat:@"- maxConcurrentOperationCount: %li\n", (unsigned long)compoundOperation.maxConcurrentOperationsCount]];
  [debugDescription appendString:@"====================================\n"];
  
  // Buffers
  id inputData = [(OperationBuffer *)compoundOperation.queueInput obtainInputDataWithTypeValidationBlock:nil];
  id outputData = [compoundOperation.queueOutput obtainOperationQueueOutputData];
  if (inputData) {
    [debugDescription appendString:@"Input Data:\n"];
    [debugDescription appendString:[NSString stringWithFormat:@"- Type: %@;\n", NSStringFromClass([inputData class])]];
    [debugDescription appendString:[NSString stringWithFormat:@"- Contents: %@;\n", inputData]];
  } else {
    [debugDescription appendString:@"No input data\n"];
  }
  if (outputData) {
    [debugDescription appendString:@"Output Data:\n"];
    [debugDescription appendString:[NSString stringWithFormat:@"- Type: %@;\n", NSStringFromClass([outputData class])]];
    [debugDescription appendString:[NSString stringWithFormat:@"- Contents: %@;\n", outputData]];
  } else {
    [debugDescription appendString:@"No output data\n"];
  }
  [debugDescription appendString:@"====================================\n"];
  
  // Dependencies
  [debugDescription appendString:@"Dependencies on other NSOperations:\n"];
  if (compoundOperation.dependencies.count > 0) {
    [debugDescription appendString:@"Depends on:\n"];
    [compoundOperation.dependencies enumerateObjectsUsingBlock:^(NSOperation *obj, NSUInteger idx, __unused BOOL *stop) {
      NSString *dependencyDescription = [NSString stringWithFormat:@"%li: %@, isExecuting: %i\n", (unsigned long)idx, NSStringFromClass([obj class]), obj.isExecuting];
      [debugDescription appendString:dependencyDescription];
    }];
  } else {
    [debugDescription appendString:@"No dependencies on other operations\n"];
  }
  [debugDescription appendString:@"====================================\n"];\
  
  // Flags
  [debugDescription appendString:@"State:\n"];
  [debugDescription appendString:[NSString stringWithFormat:@"- isQueueSuspended: %i;\n", internalQueue.isSuspended]];
  [debugDescription appendString:[NSString stringWithFormat:@"- isExecuting: %i;\n", compoundOperation.isExecuting]];
  [debugDescription appendString:[NSString stringWithFormat:@"- isFinished: %i;\n", compoundOperation.isFinished]];
  [debugDescription appendString:[NSString stringWithFormat:@"- isCancelled: %i;\n", compoundOperation.isCancelled]];
  [debugDescription appendString:[NSString stringWithFormat:@"- isReady: %i;\n", compoundOperation.isReady]];
  [debugDescription appendString:[NSString stringWithFormat:@"- isAsynchronous: %i;\n", compoundOperation.isAsynchronous]];
  [debugDescription appendString:@"====================================\n"];
  
  // Additional Information
  [debugDescription appendString:@"Additional information:\n"];
  if (compoundOperation.resultBlock) {
    [debugDescription appendString:@"resultBlock is set\n"];
  } else {
    [debugDescription appendString:@"resultBlock is not set\n"];
  }
  [debugDescription appendString:@"====================================\n"];
  
  // Executing suboperations
  NSUInteger executingOperationsCount = 0;
  for (NSOperation *operation in internalQueue.operations) {
    if (operation.isExecuting) {
      executingOperationsCount += 1;
    }
  }
  [debugDescription appendString:[NSString stringWithFormat:@"%li operations are executing right now\n", (unsigned long)executingOperationsCount]];
  if (executingOperationsCount > 0) {
    [internalQueue.operations enumerateObjectsUsingBlock:^(NSOperation *obj, NSUInteger idx, __unused BOOL *stop) {
      if (obj.isExecuting) {
        [debugDescription appendString:[NSString stringWithFormat:@"- Operation %li\n", (unsigned long)idx]];
        [debugDescription appendString:[NSString stringWithFormat:@"  - Class: %@\n", NSStringFromClass([obj class])]];
        [debugDescription appendString:@"  - Description: \n"];
        [debugDescription appendString:@"\n{{{START OF EXECUTING OPERATION DESCRIPTION}}}\n"];
        [debugDescription appendString:[obj debugDescription]];
        [debugDescription appendString:@"{{{END OF EXECUTING OPERATION DESCRIPTION}}}\n\n"];
      }
    }];
  }
  
  return [debugDescription copy];
}

@end
