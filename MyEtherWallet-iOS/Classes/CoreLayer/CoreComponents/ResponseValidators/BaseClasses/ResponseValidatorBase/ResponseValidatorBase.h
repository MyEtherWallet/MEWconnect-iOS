//
//  ResponseValidatorBase.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 21/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

FOUNDATION_EXPORT NSString *const kResponseValidationErrorDomain;

@interface ResponseValidatorBase : NSObject
- (BOOL)validateResponseIsDictionaryClass:(id)response error:(NSError **)error;
- (BOOL)validateResponseIsArrayClass:(id)response error:(NSError **)error;
@end
