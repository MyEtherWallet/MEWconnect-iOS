//
//  BottomBackgroundedModalPresentationController.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 26/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import UIKit;

@protocol BlockchainNetworkService;
@protocol Ponsomizer;

@interface BottomBackgroundedModalPresentationController : UIPresentationController
@property (nonatomic, strong) id <BlockchainNetworkService> networkService;
@property (nonatomic, strong) id <Ponsomizer> ponsomizer;
@property (nonatomic) CGFloat cornerRadius;
@end
