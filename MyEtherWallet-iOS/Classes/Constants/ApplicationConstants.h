//
//  ApplicationConstants.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 22/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

#ifndef ApplicationConstants_h
#define ApplicationConstants_h

static NSString   * const kAppGroupIdentifier                 = @"group.myetherwallet";
static NSString   * const kKeychainService                    = @"com.myetherwallet.keychainService";

static NSString   * const kCoreDataName                       = @"MEWconnect.sqlite";

static NSInteger    const kMnemonicsWordsMinLength            = 12;
static NSInteger    const kMnemonicsWordsMaxLength            = 24;

static CGFloat      const kCustomRepresentationTopBigOffset   = 55.0;
static CGFloat      const kCustomRepresentationTopSmallOffset = 8.0;

static NSInteger    const kStartDevelopmentYear               = 2018;

static NSString   * const kMyEtherWalletComURL                = @"https://www.myetherwallet.com";

#endif /* ApplicationConstants_h */
