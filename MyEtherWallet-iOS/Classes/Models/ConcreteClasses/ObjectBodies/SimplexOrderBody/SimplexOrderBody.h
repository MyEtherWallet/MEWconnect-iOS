//
//  SimplexOrderBody.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 04/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@interface SimplexOrderBody : NSObject
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *walletAddress;
@property (nonatomic, strong) NSDecimalNumber *fiatAmount;
@property (nonatomic, strong) NSDecimalNumber *digitalAmount;
@property (nonatomic, strong) NSString *appInstallDate;
@end
