//
//  ShareInteractorInput.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 11/10/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@class MasterTokenPlainObject;

@protocol ShareInteractorInput <NSObject>
- (void) configureWithMasterToken:(MasterTokenPlainObject *)masterToken;
- (NSString *) obtainPublicAddress;
- (UIImage *) obtainQRCode;
- (void) copyAddress;
- (NSArray *) shareActivityItems;
@end
