//
//  HomeTableViewCellObject.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 22/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;
@import Nimbus.NimbusModels;

@class TokenPlainObject;

@interface HomeTableViewCellObject : NSObject <NINibCellObject, NICellObject>
@property (nonatomic, strong, readonly) NSString *tokenName;
@property (nonatomic, strong, readonly) NSString *tokenPrice;
@property (nonatomic, strong, readonly) NSString *tokenBalance;
@property (nonatomic, strong, readonly) NSString *fiatBalance;
@property (nonatomic, strong, readonly) TokenPlainObject *token;
+ (instancetype) objectWithToken:(TokenPlainObject *)token;
@end

