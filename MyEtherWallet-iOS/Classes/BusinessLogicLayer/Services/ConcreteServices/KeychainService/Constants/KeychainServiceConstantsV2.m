//
//  KeychainServiceConstantsV2.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 29/10/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "KeychainServiceConstantsV2.h"

NSString *const kKeychainServiceV2ItemPrefix        = @"account";
NSString *const kKeychainServiceV2ItemFormat        = @"account_%@"; //AccountUID

NSString *const kKeychainServiceV2KeyFormat         = @"%@_%@"; //PublicAddress_chainID

NSString *const kKeychainServiceV2HistoryPrefix     = @"history";
NSString *const kKeychainServiceV2HistoryKeyFormat  = @"history_%@_%@"; //PublicAddress_chainID
