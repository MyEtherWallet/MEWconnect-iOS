//
//  RestoreOptionsDataDisplayManager.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 2/18/19.
//  Copyright © 2019 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

#import "DataDisplayManager.h"

@class RestoreOptionsCellObjectBuilder;

@protocol RestoreOptionsDataDisplayManagerDelegate <NSObject>
- (void) didTapRecoveryPhrase;
@end

NS_ASSUME_NONNULL_BEGIN

@interface RestoreOptionsDataDisplayManager : NSObject <DataDisplayManager, UITableViewDelegate>
@property (nonatomic, weak) id <RestoreOptionsDataDisplayManagerDelegate> delegate;
@property (nonatomic, strong) RestoreOptionsCellObjectBuilder *cellObjectBuilder;
- (void) updateDataDisplayManager;
@end

NS_ASSUME_NONNULL_END
