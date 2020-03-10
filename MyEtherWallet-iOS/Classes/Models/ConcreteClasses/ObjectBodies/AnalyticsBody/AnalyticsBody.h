//
//  AnalyticsBody.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 3/10/20.
//  Copyright © 2020 MyEtherWallet, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnalyticsBody : NSObject
@property (nonatomic, strong) NSArray <NSDictionary <NSString *, NSString *> *> *events;
@end
