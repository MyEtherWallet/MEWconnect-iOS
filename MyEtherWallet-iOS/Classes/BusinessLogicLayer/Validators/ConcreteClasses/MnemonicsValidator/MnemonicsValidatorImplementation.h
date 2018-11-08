//
//  MnemonicsValidatorImplementation.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 08/11/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "ObjectValidator.h"

@protocol MEWwallet;

NS_ASSUME_NONNULL_BEGIN

@interface MnemonicsValidatorImplementation : NSObject <ObjectValidator>
@property (nonatomic, strong) NSCharacterSet *separatorCharacterSet;
@property (nonatomic, strong) id <MEWwallet> walletService;
@end

NS_ASSUME_NONNULL_END
