//
//  ConfirmationUIStringList.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 3/20/19.
//  Copyright © 2019 MyEtherWallet, Inc. All rights reserved.
//

#import "UIStringList.h"

NS_ASSUME_NONNULL_BEGIN

@interface ConfirmationUIStringList : UIStringList

#pragma mark - Confirmation
@property (class, strong, readonly) NSString *confirmationUnknownTokenCurrencySymbol;
@property (class, strong, readonly) NSString *confirmationUnknownTokenDescription;
@property (class, strong, readonly) NSString *confirmationCheckAddressShortVersion;
@property (class, strong, readonly) NSString *confirmationCheckAddressFullVersion;
@property (class, strong, readonly) NSString *confirmationCheckAmount;
@property (class, strong, readonly) NSString *confirmationCheckNetwork;

@end

NS_ASSUME_NONNULL_END
