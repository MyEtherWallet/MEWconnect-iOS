//
//  WhatsNewServiceImplementation.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 3/21/19.
//  Copyright © 2019 MyEtherWallet, Inc. All rights reserved.
//

#import "WhatsNewService.h"

@protocol KeychainService;

@interface WhatsNewServiceImplementation : NSObject <WhatsNewService>
@property (nonatomic, strong) NSFileManager *fileManager;
@property (nonatomic, strong) id <KeychainService> keychainService;
- (instancetype) initWithFileManager:(NSFileManager *)fileManager;
@end
