//
//  NavigationControllerFactoryImplementation.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 15/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import ViperMcFlurry;

#import "NavigationControllerFactoryImplementation.h"

#import "HomeModuleInput.h"

static NSString *const kHomeViewControllerIdentifier            = @"HomeViewController";

@interface NavigationControllerFactoryImplementation ()
@property (nonatomic, strong) UIStoryboard *storyboard;
@end

@implementation NavigationControllerFactoryImplementation

#pragma mark - Initialization

- (instancetype)initWithStoryboard:(UIStoryboard *)storyboard {
  self = [super init];
  if (self) {
    _storyboard = storyboard;
  }
  return self;
}

+ (instancetype)factoryWithStoryboard:(UIStoryboard *)storyboard {
  return [[self alloc] initWithStoryboard:storyboard];
}

#pragma mark - NavigationControllerFactory

- (UINavigationController *)obtainPreconfiguredNavigationController {
  UINavigationController *navigationController = [self.storyboard instantiateInitialViewController];
  return navigationController;
}

- (UINavigationController *) obtainPreconfiguredAuthorizedNavigationControllerWithAddress:(NSString *)address {
  if (!address) {
    return [self obtainPreconfiguredNavigationController];
  } else {
    UINavigationController *navigationController = [self.storyboard instantiateInitialViewController];
    
    RamblerViperModuleFactory *homeFactory = [[RamblerViperModuleFactory alloc] initWithStoryboard:self.walletStoryboard
                                                                                  andRestorationId:kHomeViewControllerIdentifier];
    [[navigationController.topViewController openModuleUsingFactory:homeFactory
                                                withTransitionBlock:[self homeTransitionBlock]]
     thenChainUsingBlock:[self homeConfigurationBlockWithAddress:address]];
    return navigationController;
  }
}

#pragma mark - Private 

- (ModuleTransitionBlock) homeTransitionBlock {
  return ^(id<RamblerViperModuleTransitionHandlerProtocol> sourceModuleTransitionHandler, id<RamblerViperModuleTransitionHandlerProtocol> destinationModuleTransitionHandler) {
    UIViewController *destinationViewController = (id)destinationModuleTransitionHandler;
    UINavigationController *navigationController = [(id)sourceModuleTransitionHandler navigationController];
    [navigationController pushViewController:destinationViewController
                                    animated:NO];
  };
}

- (RamblerViperModuleLinkBlock) homeConfigurationBlockWithAddress:(NSString *)address {
  return ^id<RamblerViperModuleOutput>(id<HomeModuleInput> moduleInput) {
    [moduleInput configureModuleWithAddress:address];
    return nil;
  };
}

@end
