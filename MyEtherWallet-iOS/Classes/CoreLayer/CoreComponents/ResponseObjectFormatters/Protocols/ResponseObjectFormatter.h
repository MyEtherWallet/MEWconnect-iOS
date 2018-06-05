//
//  ResponseObjectFormatter.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 22/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@protocol ResponseObjectFormatter <NSObject>
- (id)formatServerResponse:(id)serverResponse;
@end
