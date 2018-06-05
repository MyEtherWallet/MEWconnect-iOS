//
//  ChainableOperationInput.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 20/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

typedef BOOL(^ChainableOperationInputTypeValidationBlock)(id data);

@protocol ChainableOperationInput <NSObject>
- (id) obtainInputDataWithTypeValidationBlock:(ChainableOperationInputTypeValidationBlock)block;
@end
