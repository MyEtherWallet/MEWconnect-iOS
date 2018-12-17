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
#import "QRScannerModuleInput.h"
#import "ContextPasswordModuleInput.h"
#import "RestoreSeedModuleInput.h"

#import "ConfirmationStoryModuleOutput.h"
#import "ContextPasswordModuleOutput.h"
#import "RestoreSeedModuleOutput.h"

static NSString *const kHomeToScannerSegueIdentifier          = @"HomeToScannerSegueIdentifier";
static NSString *const kHomeToMessageSignerSegueIdentifier    = @"HomeToMessageSignerSegueIdentifier";
static NSString *const kHomeToTransactionSegueIdentifier      = @"HomeToTransactionSegueIdentifier";
static NSString *const kHomeToBackupInfoSegueIdentifier       = @"HomeToBackupInfoSegueIdentifier";
static NSString *const kHomeToInfoSegueIdentifier             = @"HomeToInfoSegueIdentifier";
static NSString *const kHomeToBuyEtherSegueIdentifier         = @"HomeToBuyEtherSegueIdentifier";
static NSString *const kHomeToStartUnwindSegueIdentifier      = @"HomeToStartUnwindSegueIdentifier";
static NSString *const kHomeToShareSegueIdentifier            = @"HomeToShareSegueIdentifier";
static NSString *const kHomeToContextPasswordSegueIdentifier  = @"HomeToContextPasswordSegueIdentifier";
static NSString *const kHomeToRestoreSeedSegueIdentifier      = @"HomeToRestoreSeedSegueIdentifier";

@implementation HomeRouter

#pragma mark - HomeRouterInput

- (void) unwindToStart {
  [[self.transitionHandler openModuleUsingSegue:kHomeToStartUnwindSegueIdentifier] thenChainUsingBlock:^id<RamblerViperModuleOutput>(id<StartModuleInput> moduleInput) {
    [moduleInput configureModule];
    return nil;
  }];
}

- (void) openScanner {
  [[self.transitionHandler openModuleUsingSegue:kHomeToScannerSegueIdentifier] thenChainUsingBlock:^id<RamblerViperModuleOutput>(id<QRScannerModuleInput> moduleInput) {
    [moduleInput configureModule];
    return nil;
  }];
}

- (void) openShareWithMasterToken:(MasterTokenPlainObject *)masterToken {
  [[self.transitionHandler openModuleUsingSegue:kHomeToShareSegueIdentifier] thenChainUsingBlock:^id<RamblerViperModuleOutput>(id<ShareModuleInput> moduleInput) {
    [moduleInput configureModuleWithMasterToken:masterToken];
    return nil;
  }];
}

- (void)openContextPasswordWithOutput:(id<ContextPasswordModuleOutput>)output account:(AccountPlainObject *)account {
  [[self.transitionHandler openModuleUsingSegue:kHomeToContextPasswordSegueIdentifier] thenChainUsingBlock:^id<ContextPasswordModuleOutput>(id<ContextPasswordModuleInput> moduleInput) {
    [moduleInput configureModuleWithAccount:account type:ContextPasswordTypeBackup];
    return output;
  }];
}

- (void) openRestoreSeedWithAccount:(AccountPlainObject *)account password:(NSString *)password moduleOutput:(id <RestoreSeedModuleOutput>)output {
  [[self.transitionHandler openModuleUsingSegue:kHomeToRestoreSeedSegueIdentifier] thenChainUsingBlock:^id<RestoreSeedModuleOutput>(id<RestoreSeedModuleInput> moduleInput) {
    [moduleInput configureModuleWithAccount:account password:password];
    return output;
  }];
}

- (id<ConfirmationNavigationModuleInput>)openMessageSignerWithMessage:(MEWConnectCommand *)command masterToken:(MasterTokenPlainObject *)masterToken confirmationDelegate:(id<ConfirmationStoryModuleOutput>)confirmationDelegate {
  id <RamblerViperModuleInput> originalModuleInput = nil;
  RamblerViperOpenModulePromise *promise = [self promiseWithFactory:self.messageSignerFactory
                                                withTransitionBlock:^(id<RamblerViperModuleTransitionHandlerProtocol> sourceModuleTransitionHandler, id<RamblerViperModuleTransitionHandlerProtocol> destinationModuleTransitionHandler) {
                                                  UIViewController *fromViewController = (UIViewController *)sourceModuleTransitionHandler;
                                                  UIViewController *toViewController = (UIViewController *)destinationModuleTransitionHandler;
                                                  
                                                  UINavigationController *fromNavigationController = [fromViewController navigationController];
                                                  [fromNavigationController.visibleViewController presentViewController:toViewController animated:YES completion:nil];
                                                } originalModuleInput:&originalModuleInput];
  [promise thenChainUsingBlock:^id<ConfirmationStoryModuleOutput>(id<MessageSignerModuleInput> moduleInput) {
    [moduleInput configureModuleWithMessage:command masterToken:masterToken];
    return confirmationDelegate;
  }];
  if ([originalModuleInput conformsToProtocol:@protocol(ConfirmationNavigationModuleInput)]) {
    return (id <ConfirmationNavigationModuleInput>)originalModuleInput;
  }
  return nil;
}

- (id <ConfirmationNavigationModuleInput>) openTransactionSignerWithMessage:(MEWConnectCommand *)command masterToken:(MasterTokenPlainObject *)masterToken confirmationDelegate:(id<ConfirmationStoryModuleOutput>)confirmationDelegate {
  id <RamblerViperModuleInput> originalModuleInput = nil;
  RamblerViperOpenModulePromise *promise = [self promiseWithFactory:self.transactionFactory
                                                withTransitionBlock:^(id<RamblerViperModuleTransitionHandlerProtocol> sourceModuleTransitionHandler, id<RamblerViperModuleTransitionHandlerProtocol> destinationModuleTransitionHandler) {
                                                  UIViewController *fromViewController = (UIViewController *)sourceModuleTransitionHandler;
                                                  UIViewController *toViewController = (UIViewController *)destinationModuleTransitionHandler;
                                                  
                                                  UINavigationController *fromNavigationController = [fromViewController navigationController];
                                                  [fromNavigationController.visibleViewController presentViewController:toViewController animated:YES completion:nil];
                                                } originalModuleInput:&originalModuleInput];
  [promise thenChainUsingBlock:^id<ConfirmationStoryModuleOutput>(id<TransactionModuleInput> moduleInput) {
    [moduleInput configureModuleWithMessage:command masterToken:masterToken];
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

- (void) openInfo {
  [[self.transitionHandler openModuleUsingSegue:kHomeToInfoSegueIdentifier] thenChainUsingBlock:^id<RamblerViperModuleOutput>(id<InfoModuleInput> moduleInput) {
    [moduleInput configureModule];
    return nil;
  }];
}

- (void) openBuyEtherWithMasterToken:(MasterTokenPlainObject *)masterToken {
  [[self.transitionHandler openModuleUsingSegue:kHomeToBuyEtherSegueIdentifier] thenChainUsingBlock:^id<RamblerViperModuleOutput>(id<BuyEtherAmountModuleInput> moduleInput) {
    [moduleInput configureModuleWithMasterToken:masterToken];
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
