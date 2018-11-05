//
//  RestoreSeedViewInput.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 04/11/2018.
//  Copyright © 2018 MyEtherWallet, Inc.. All rights reserved.
//

@import Foundation;

@protocol RestoreSeedViewInput <NSObject>
- (void) setupInitialState;
- (void) enableNext:(BOOL)enable;
- (void) presentIncorrectMnemonicsWarning;
- (void) presentInvalidMnemonicsWarning;
@end
