//
//  HomeRouter.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import ViperMcFlurryX;
@import libextobjc.EXTScope;

#import "HomeRouter.h"

#import "MessageSignerModuleInput.h"
#import "TransactionModuleInput.h"
#import "BackupInfoModuleInput.h"
#import "InfoModuleInput.h"
#import "BuyEtherAmountModuleInput.h"
#import "ConfirmationNavigationModuleInput.h"
#import "StartModuleInput.h"
#import "ShareModuleInput.h"

#import "ConfirmationStoryModuleOutput.h"

static NSString *const kHomeToScannerSegueIdentifier        = @"HomeToScannerSegueIdentifier";
static NSString *const kHomeToMessageSignerSegueIdentifier  = @"HomeToMessageSignerSegueIdentifier";
static NSString *const kHomeToTransactionSegueIdentifier    = @"HomeToTransactionSegueIdentifier";
static NSString *const kHomeToBackupInfoSegueIdentifier     = @"HomeToBackupInfoSegueIdentifier";
static NSString *const kHomeToInfoSegueIdentifier           = @"HomeToInfoSegueIdentifier";
static NSString *const kHomeToBuyEtherSegueIdentifier       = @"HomeToBuyEtherSegueIdentifier";
static NSString *const kHomeToStartUnwindSegueIdentifier    = @"HomeToStartUnwindSegueIdentifier";
static NSString *const kHomeToShareSegueIdentifier          = @"HomeToShareSegueIdentifier";

@implementation HomeRouter

#pragma mark - HomeRouterInput

- (void) unwindToStart {
  [[self.transitionHandler openModuleUsingSegue:kHomeToStartUnwindSegueIdentifier] thenChainUsingBlock:^id<RamblerViperModuleOutput>(id<StartModuleInput> moduleInput) {
    [moduleInput configureModule];
    return nil;
  }];
}

- (void) openScanner {
  [[self.transitionHandler openModuleUsingSegue:kHomeToScannerSegueIdentifier] thenChainUsingBlock:^id<RamblerViperModuleOutput>(id<RamblerViperModuleInput> moduleInput) {
    return nil;
  }];
}

- (void) openShareWithAccount:(AccountPlainObject *)account {
  [[self.transitionHandler openModuleUsingSegue:kHomeToShareSegueIdentifier] thenChainUsingBlock:^id<RamblerViperModuleOutput>(id<ShareModuleInput> moduleInput) {
    [moduleInput configureModuleWithAccount:account];
    return nil;
  }];
}

- (id<ConfirmationNavigationModuleInput>)openMessageSignerWithMessage:(MEWConnectCommand *)command account:(AccountPlainObject *)account confirmationDelegate:(id<ConfirmationStoryModuleOutput>)confirmationDelegate {
  id <RamblerViperModuleInput> originalModuleInput = nil;
  RamblerViperOpenModulePromise *promise = [self promiseWithFactory:self.messageSignerFactory
                                                withTransitionBlock:^(id<RamblerViperModuleTransitionHandlerProtocol> sourceModuleTransitionHandler, id<RamblerViperModuleTransitionHandlerProtocol> destinationModuleTransitionHandler) {
                                                  UIViewController *fromViewController = (UIViewController *)sourceModuleTransitionHandler;
                                                  UIViewController *toViewController = (UIViewController *)destinationModuleTransitionHandler;
                                                  
                                                  UINavigationController *fromNavigationController = [fromViewController navigationController];
                                                  [fromNavigationController.visibleViewController presentViewController:toViewController animated:YES completion:nil];
                                                } originalModuleInput:&originalModuleInput];
  [promise thenChainUsingBlock:^id<ConfirmationStoryModuleOutput>(id<MessageSignerModuleInput> moduleInput) {
    [moduleInput configureModuleWithMessage:command account:account];
    return confirmationDelegate;
  }];
  if ([originalModuleInput conformsToProtocol:@protocol(ConfirmationNavigationModuleInput)]) {
    return (id <ConfirmationNavigationModuleInput>)originalModuleInput;
  }
  return nil;
}

- (id <ConfirmationNavigationModuleInput>) openTransactionSignerWithMessage:(MEWConnectCommand *)command account:(AccountPlainObject *)account confirmationDelegate:(id<ConfirmationStoryModuleOutput>)confirmationDelegate {
  id <RamblerViperModuleInput> originalModuleInput = nil;
  RamblerViperOpenModulePromise *promise = [self promiseWithFactory:self.transactionFactory
                                                withTransitionBlock:^(id<RamblerViperModuleTransitionHandlerProtocol> sourceModuleTransitionHandler, id<RamblerViperModuleTransitionHandlerProtocol> destinationModuleTransitionHandler) {
                                                  UIViewController *fromViewController = (UIViewController *)sourceModuleTransitionHandler;
                                                  UIViewController *toViewController = (UIViewController *)destinationModuleTransitionHandler;
                                                  
                                                  UINavigationController *fromNavigationController = [fromViewController navigationController];
                                                  [fromNavigationController.visibleViewController presentViewController:toViewController animated:YES completion:nil];
                                                } originalModuleInput:&originalModuleInput];
  [promise thenChainUsingBlock:^id<ConfirmationStoryModuleOutput>(id<TransactionModuleInput> moduleInput) {
    [moduleInput configureModuleWithMessage:command account:account];
    return confirmationDelegate;
  }];
  if ([originalModuleInput conformsToProtocol:@protocol(ConfirmationNavigationModuleInput)]) {
    return (id <ConfirmationNavigationModuleInput>)originalModuleInput;
  }
  return nil;
}

- (void) openBackupWithAccount:(AccountPlainObject *)account {
  [[self.transitionHandler openModuleUsingSegue:kHomeToBackupInfoSegueIdentifier] thenChainUsingBlock:^id<RamblerViperModuleOutput>(id<BackupInfoModuleInput> moduleInput) {
    [moduleInput configureModuleWithAccount:account];
    return nil;
  }];
}

- (void) openInfoWithAccount:(AccountPlainObject *)account {
  [[self.transitionHandler openModuleUsingSegue:kHomeToInfoSegueIdentifier] thenChainUsingBlock:^id<RamblerViperModuleOutput>(id<InfoModuleInput> moduleInput) {
    [moduleInput configureModuleWithAccount:account];
    return nil;
  }];
}

- (void) openBuyEtherWithAccount:(AccountPlainObject *)account {
  [[self.transitionHandler openModuleUsingSegue:kHomeToBuyEtherSegueIdentifier] thenChainUsingBlock:^id<RamblerViperModuleOutput>(id<BuyEtherAmountModuleInput> moduleInput) {
    [moduleInput configureModuleWithAccount:account];
    return nil;
  }];
}

#pragma mark - Private

- (RamblerViperOpenModulePromise*) promiseWithFactory:(RamblerViperModuleFactory *)moduleFactory withTransitionBlock:(ModuleTransitionBlock)transitionBlock originalModuleInput:(id <RamblerViperModuleInput> *)originalModuleInput {
  RamblerViperOpenModulePromise *openModulePromise = [[RamblerViperOpenModulePromise alloc] init];
  id<RamblerViperModuleTransitionHandlerProtocol> destinationModuleTransitionHandler = [moduleFactory instantiateModuleTransitionHandler];
  
  id<RamblerViperModuleInput> moduleInput = nil;
  if ([destinationModuleTransitionHandler respondsToSelector:@selector(moduleInput)]) {
    moduleInput = [destinationModuleTransitionHandler moduleInput];
  }
  
  *originalModuleInput = moduleInput;
  
  UIViewController *toViewController = (UIViewController *)destinationModuleTransitionHandler;
  if ([toViewController isKindOfClass:[UINavigationController class]]) {
    UINavigationController *navigationController = (UINavigationController *)toViewController;
    toViewController = navigationController.topViewController;
    if ([toViewController respondsToSelector:@selector(moduleInput)]) {
      moduleInput = [toViewController moduleInput];
    }
  }
  
  openModulePromise.moduleInput = moduleInput;
  if (transitionBlock != nil) {
    openModulePromise.postLinkActionBlock = ^{
      transitionBlock(self.transitionHandler,destinationModuleTransitionHandler);
    };
  }
  return openModulePromise;
}

@end
