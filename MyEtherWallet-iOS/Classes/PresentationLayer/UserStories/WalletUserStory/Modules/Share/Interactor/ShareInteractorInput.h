//
//  ShareInteractorInput.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 11/10/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

#import "BlockchainNetworkTypes.h"

@class MasterTokenPlainObject;

@protocol ShareInteractorInput <NSObject>
- (void) configureWithMasterToken:(MasterTokenPlainObject *)masterToken;
- (NSString *) obtainPublicAddress;
- (UIImage *) obtainQRCode;
- (BlockchainNetworkType) obtainNetworkType;
- (void) copyAddress;
- (NSArray *) shareActivityItems;
@end
