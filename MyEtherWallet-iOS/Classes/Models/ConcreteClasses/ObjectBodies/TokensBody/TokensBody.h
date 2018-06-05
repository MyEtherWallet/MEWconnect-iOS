//
//  TokensBody.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 22/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@interface TokensBody : NSObject
@property (nonatomic, strong) NSString  * address;
@property (nonatomic, strong) NSArray   * contractAddresses;
@property (nonatomic, strong) NSString  * abi;
@property (nonatomic, strong) NSString  * method;
@property (nonatomic) BOOL nameRequired;
@property (nonatomic) BOOL websiteRequired;
@property (nonatomic) BOOL emailRequired;
@property (nonatomic) NSInteger count;
@end
