//
//  ContextPasswordAssemblyTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 11/09/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import RamblerTyphoonUtils.AssemblyTesting;
@import Typhoon;

#import "ContextPasswordAssembly.h"
#import "ContextPasswordAssembly_Testable.h"

#import "ContextPasswordViewController.h"
#import "ContextPasswordPresenter.h"
#import "ContextPasswordInteractor.h"
#import "ContextPasswordRouter.h"

@interface ContextPasswordAssemblyTests : RamblerTyphoonAssemblyTests

@property (nonatomic, strong) ContextPasswordAssembly *assembly;

@end

@implementation ContextPasswordAssemblyTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.assembly = [[ContextPasswordAssembly alloc] init];
    [self.assembly activate];
}

- (void)tearDown {
    self.assembly = nil;

    [super tearDown];
}

#pragma mark - Assembly tests

- (void)testThatAssemblyCreatesViewController {
    // given
    Class targetClass = [ContextPasswordViewController class];
    NSArray *protocols = @[
                           @protocol(ContextPasswordViewInput)
                           ];
    NSArray *dependencies = @[
                              RamblerSelector(output)
                              ];
    RamblerTyphoonAssemblyTestsTypeDescriptor *descriptor = [RamblerTyphoonAssemblyTestsTypeDescriptor descriptorWithClass:targetClass
                                                                                                              andProtocols:protocols];

    // when
    id result = [self.assembly viewContextPassword];

    // then
    [self verifyTargetDependency:result
                  withDescriptor:descriptor
                    dependencies:dependencies];
}

- (void)testThatAssemblyCreatesPresenter {
    // given
    Class targetClass = [ContextPasswordPresenter class];
    NSArray *protocols = @[
                           @protocol(ContextPasswordModuleInput),
                           @protocol(ContextPasswordViewOutput),
                           @protocol(ContextPasswordInteractorOutput)
                           ];
    NSArray *dependencies = @[
                              RamblerSelector(interactor),
                              RamblerSelector(view),
                              RamblerSelector(router)
                              ];
    RamblerTyphoonAssemblyTestsTypeDescriptor *descriptor = [RamblerTyphoonAssemblyTestsTypeDescriptor descriptorWithClass:targetClass
                                                                                                              andProtocols:protocols];

    // when
    id result = [self.assembly presenterContextPassword];

    // then
    [self verifyTargetDependency:result
                  withDescriptor:descriptor
                    dependencies:dependencies];
}

- (void)testThatAssemblyCreatesInteractor {
    // given
    Class targetClass = [ContextPasswordInteractor class];
    NSArray *protocols = @[
                           @protocol(ContextPasswordInteractorInput)
                           ];
    NSArray *dependencies = @[
                              RamblerSelector(output)
                              ];
    RamblerTyphoonAssemblyTestsTypeDescriptor *descriptor = [RamblerTyphoonAssemblyTestsTypeDescriptor descriptorWithClass:targetClass
                                                                                                              andProtocols:protocols];
													      
    // when
    id result = [self.assembly interactorContextPassword];

    // then
    [self verifyTargetDependency:result
                  withDescriptor:descriptor
                    dependencies:dependencies];
}

- (void)testThatAssemblyCreatesRouter {
    // given
    Class targetClass = [ContextPasswordRouter class];
    NSArray *protocols = @[
                           @protocol(ContextPasswordRouterInput)
                           ];
    NSArray *dependencies = @[
                              RamblerSelector(transitionHandler)
                              ];
    RamblerTyphoonAssemblyTestsTypeDescriptor *descriptor = [RamblerTyphoonAssemblyTestsTypeDescriptor descriptorWithClass:targetClass
                                                                                                              andProtocols:protocols];

    // when
    id result = [self.assembly routerContextPassword];

    // then
    [self verifyTargetDependency:result
                  withDescriptor:descriptor
                    dependencies:dependencies];
}

@end
