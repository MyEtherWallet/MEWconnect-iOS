//
//  InfoDestructiveTableViewCellObject.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 24/06/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;
@import Nimbus.NimbusModels;

typedef NS_ENUM(short, InfoDestructiveTableViewCellObjectType) {
  InfoDestructiveTableViewCellObjectResetType   = 0,
};

@interface InfoDestructiveTableViewCellObject : NSObject <NINibCellObject, NICellObject>
@property (nonatomic, readonly) InfoDestructiveTableViewCellObjectType type;
@property (nonatomic, strong, readonly) NSString *title;
+ (instancetype) objectWithType:(InfoDestructiveTableViewCellObjectType)type;
@end
