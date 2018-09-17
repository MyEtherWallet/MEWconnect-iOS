//
//  KeychainServiceImplementation.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 29/06/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "KeychainService.h"

@class UICKeyChainStore;

@interface KeychainServiceImplementation : NSObject <KeychainService>
@property (nonatomic, strong) UICKeyChainStore *keychainStore;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@end
