//
//  WhatsNewService.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 3/21/19.
//  Copyright © 2019 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@protocol WhatsNewService <NSObject>
- (BOOL) shouldShowWhatsNew;
- (void) registerShow;
- (NSString *) currentWhatsNew;
@end
