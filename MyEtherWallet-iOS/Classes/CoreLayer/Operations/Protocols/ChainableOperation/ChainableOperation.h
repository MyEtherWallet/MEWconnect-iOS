//
//  ChainableOperation.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 20/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

#import "ChainableOperationInput.h"
#import "ChainableOperationOutput.h"
#import "ChainableOperationDelegate.h"
#import "OperationDebugDescriptionFormatter.h"

@protocol ChainableOperation <NSObject>
@property (nonatomic, weak) id<ChainableOperationDelegate> delegate;
@property (nonatomic, strong) id<ChainableOperationInput> input;
@property (nonatomic, strong) id<ChainableOperationOutput> output;
@end
