//
//  ConfirmationNavigationAssemblyTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 17/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import RamblerTyphoonUtils.AssemblyTesting;
@import Typhoon;

#import "ConfirmationNavigationAssembly.h"
#import "ConfirmationNavigationAssembly_Testable.h"

#import "ConfirmationNavigationViewController.h"
#import "ConfirmationNavigationPresenter.h"
#import "ConfirmationNavigationInteractor.h"
#import "ConfirmationNavigationRouter.h"

@interface ConfirmationNavigationAssemblyTests : RamblerTyphoonAssemblyTests

@property (nonatomic, strong) ConfirmationNavigationAssembly *assembly;

@end

@implementation ConfirmationNavigationAssemblyTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.assembly = [[ConfirmationNavigationAssembly alloc] init];
    [self.assembly activate];
}

- (void)tearDown {
    self.assembly = nil;

    [super tearDown];
}

#pragma mark - Assembly tests

- (void)testThatAssemblyCreatesViewController {
    // given
    Class targetClass = [ConfirmationNavigationViewController class];
    NSArray *protocols = @[
                           @protocol(ConfirmationNavigationViewInput)
                           ];
    NSArray *dependencies = @[
                              RamblerSelector(output)
                              ];
    RamblerTyphoonAssemblyTestsTypeDescriptor *descriptor = [RamblerTyphoonAssemblyTestsTypeDescriptor descriptorWithClass:targetClass
                                                                                                              andProtocols:protocols];

    // when
    id result = [self.assembly viewConfirmationNavigation];

    // then
    [self verifyTargetDependency:result
                  withDescriptor:descriptor
                    dependencies:dependencies];
}

- (void)testThatAssemblyCreatesPresenter {
    // given
    Class targetClass = [ConfirmationNavigationPresenter class];
    NSArray *protocols = @[
                           @protocol(ConfirmationNavigationModuleInput),
                           @protocol(ConfirmationNavigationViewOutput),
                           @protocol(ConfirmationNavigationInteractorOutput)
                           ];
    NSArray *dependencies = @[
                              RamblerSelector(interactor),
                              RamblerSelector(view),
                              RamblerSelector(router)
                              ];
    RamblerTyphoonAssemblyTestsTypeDescriptor *descriptor = [RamblerTyphoonAssemblyTestsTypeDescriptor descriptorWithClass:targetClass
                                                                                                              andProtocols:protocols];

    // when
    id result = [self.assembly presenterConfirmationNavigation];

    // then
    [self verifyTargetDependency:result
                  withDescriptor:descriptor
                    dependencies:dependencies];
}

- (void)testThatAssemblyCreatesInteractor {
    // given
    Class targetClass = [ConfirmationNavigationInteractor class];
    NSArray *protocols = @[
                           @protocol(ConfirmationNavigationInteractorInput)
                           ];
    NSArray *dependencies = @[
                              RamblerSelector(output)
                              ];
    RamblerTyphoonAssemblyTestsTypeDescriptor *descriptor = [RamblerTyphoonAssemblyTestsTypeDescriptor descriptorWithClass:targetClass
                                                                                                              andProtocols:protocols];
													      
    // when
    id result = [self.assembly interactorConfirmationNavigation];

    // then
    [self verifyTargetDependency:result
                  withDescriptor:descriptor
                    dependencies:dependencies];
}

- (void)testThatAssemblyCreatesRouter {
    // given
    Class targetClass = [ConfirmationNavigationRouter class];
    NSArray *protocols = @[
                           @protocol(ConfirmationNavigationRouterInput)
                           ];
    NSArray *dependencies = @[
                              RamblerSelector(transitionHandler)
                              ];
    RamblerTyphoonAssemblyTestsTypeDescriptor *descriptor = [RamblerTyphoonAssemblyTestsTypeDescriptor descriptorWithClass:targetClass
                                                                                                              andProtocols:protocols];

    // when
    id result = [self.assembly routerConfirmationNavigation];

    // then
    [self verifyTargetDependency:result
                  withDescriptor:descriptor
                    dependencies:dependencies];
}

@end
