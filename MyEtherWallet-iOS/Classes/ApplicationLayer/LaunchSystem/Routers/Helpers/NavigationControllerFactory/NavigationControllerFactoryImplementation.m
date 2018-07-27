//
//  NavigationControllerFactoryImplementation.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 15/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import ViperMcFlurryX;

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

- (UINavigationController *) obtainPreconfiguredAuthorizedNavigationController {
  UINavigationController *navigationController = [self.storyboard instantiateInitialViewController];
  
  RamblerViperModuleFactory *homeFactory = [[RamblerViperModuleFactory alloc] initWithViewControllerLoader:self.walletStoryboard
                                                                               andViewControllerIdentifier:kHomeViewControllerIdentifier];
  [[navigationController.topViewController openModuleUsingFactory:homeFactory
                                              withTransitionBlock:[self homeTransitionBlock]]
   thenChainUsingBlock:[self homeConfigurationBlock]];
  return navigationController;
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

- (RamblerViperModuleLinkBlock) homeConfigurationBlock {
  return ^id<RamblerViperModuleOutput>(id<HomeModuleInput> moduleInput) {
    [moduleInput configureModule];
    return nil;
  };
}

@end
