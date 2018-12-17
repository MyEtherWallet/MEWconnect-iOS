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

static CGFloat      const kCustomRepresentationTopBigOffset   = 90.0;
static CGFloat      const kCustomRepresentationTopSmallOffset = 8.0;

static NSInteger    const kStartDevelopmentYear               = 2018;

static NSString   * const kMyEtherWalletComURL                = @"https://www.myetherwallet.com";
static NSString   * const kKnowledgeBaseURL                   = @"https://myetherwallet.github.io/knowledge-base/";
static NSString   * const kMyEtherWalletSupportEmail          = @"support@myetherwallet.com";
static NSString   * const kUserGuideURL                       = @"https://kb.myetherwallet.com/getting-started/mew-connect-user-guide.html";
static NSString   * const kPrivacyAndTermsURL                 = @"https://www.myetherwallet.com/privacy-policy.html";

#endif /* ApplicationConstants_h */
