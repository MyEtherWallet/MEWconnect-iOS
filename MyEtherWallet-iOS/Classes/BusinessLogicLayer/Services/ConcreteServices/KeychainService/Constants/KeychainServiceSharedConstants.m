//
//  KeychainServiceSharedConstants.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 29/10/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "KeychainServiceSharedConstants.h"

NSString *const kKeychainServiceFirstLaunchField            = @"firstLaunch";

NSString *const kKeychainServiceRateAskedValue              = @"true";
NSString *const kKeychainServiceRateAskedField              = @"com.myetherwallet.rater.rateasked";

NSString *const kKeychainServiceVersionField                = @"com.myetherwallet.keychain.version";

NSString *const kKeychainServiceEntropyField                = @"entropy";
NSString *const kKeychainServiceBackupField                 = @"backup";

NSString *const kKeychainServicePurchaseUserIdField         = @"userId";
NSString *const kKeychainServicePurchaseDateField           = @"date";

//Current version
NSString *const kKeychainServiceCurrentKeychainVersionField = @"version";
NSInteger const kKeychainServiceCurrentKeychainVersionValue = 2;
