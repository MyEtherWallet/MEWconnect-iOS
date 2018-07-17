//
//  BuyEtherWebInteractor.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 05/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc.. All rights reserved.
//

#import "BuyEtherWebInteractor.h"

#import "BuyEtherWebInteractorOutput.h"

#import "SimplexService.h"

@interface BuyEtherWebInteractor ()
@property (nonatomic, strong) AccountPlainObject *account;
@property (nonatomic, strong) SimplexOrder *order;
@end

@implementation BuyEtherWebInteractor

#pragma mark - BuyEtherWebInteractorInput

- (void) configurateWithOrder:(SimplexOrder *)order account:(AccountPlainObject *)account {
  _account = account;
  _order = order;
}

- (NSURLRequest *) obtainInitialRequest {
  return [self.simplexService obtainRequestWithOrder:self.order forAccount:self.account];
}

@end
