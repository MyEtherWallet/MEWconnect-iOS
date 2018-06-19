//
//  BottomBackgroundedModalPresentationController.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 26/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import UIKit;

@protocol MEWWallet;

@interface BottomBackgroundedModalPresentationController : UIPresentationController
@property (nonatomic, strong) id <MEWWallet> walletService;
@property (nonatomic) CGFloat cornerRadius;
@end
