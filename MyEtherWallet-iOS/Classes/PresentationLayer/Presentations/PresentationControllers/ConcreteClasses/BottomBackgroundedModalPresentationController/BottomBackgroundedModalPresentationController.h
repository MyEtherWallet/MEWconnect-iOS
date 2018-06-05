//
//  BottomBackgroundedModalPresentationController.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 26/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import UIKit;

@protocol MEWCrypto;

@interface BottomBackgroundedModalPresentationController : UIPresentationController
@property (nonatomic, strong) id <MEWCrypto> cryptoService;
@property (nonatomic) CGFloat cornerRadius;
@end
