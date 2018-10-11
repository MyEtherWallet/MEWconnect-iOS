//
//  ShareViewInput.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 11/10/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@protocol ShareViewInput <NSObject>
- (void) setupInitialStateWithAddress:(NSString *)address qrCode:(UIImage *)qrCode;
- (void) presentShareWithItems:(NSArray *)items;
@end
