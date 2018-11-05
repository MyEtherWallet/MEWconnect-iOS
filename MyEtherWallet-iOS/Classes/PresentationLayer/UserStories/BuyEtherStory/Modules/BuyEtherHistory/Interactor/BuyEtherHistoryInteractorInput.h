//
//  BuyEtherHistoryInteractorInput.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 02/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@class MasterTokenPlainObject;

@protocol BuyEtherHistoryInteractorInput <NSObject>
- (void) configureWithMasterToken:(MasterTokenPlainObject *)masterToken;
@end
