//
//  RestoreSeedAssemblyTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 04/11/2018.
//  Copyright © 2018 MyEtherWallet, Inc.. All rights reserved.
//

@import RamblerTyphoonUtils.AssemblyTesting;
@import Typhoon;

#import "RestoreSeedAssembly.h"
#import "RestoreSeedAssembly_Testable.h"

#import "RestoreSeedViewController.h"
#import "RestoreSeedPresenter.h"
#import "RestoreSeedInteractor.h"
#import "RestoreSeedRouter.h"

@interface RestoreSeedAssemblyTests : RamblerTyphoonAssemblyTests

@property (nonatomic, strong) RestoreSeedAssembly *assembly;

@end

@implementation RestoreSeedAssemblyTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.assembly = [[RestoreSeedAssembly alloc] init];
    [self.assembly activate];
}

- (void)tearDown {
    self.assembly = nil;

    [super tearDown];
}

#pragma mark - Assembly tests

- (void)testThatAssemblyCreatesViewController {
    // given
    Class targetClass = [RestoreSeedViewController class];
    NSArray *protocols = @[
                           @protocol(RestoreSeedViewInput)
                           ];
    NSArray *dependencies = @[
                              RamblerSelector(output)
                              ];
    RamblerTyphoonAssemblyTestsTypeDescriptor *descriptor = [RamblerTyphoonAssemblyTestsTypeDescriptor descriptorWithClass:targetClass
                                                                                                              andProtocols:protocols];

    // when
    id result = [self.assembly viewRestoreSeed];

    // then
    [self verifyTargetDependency:result
                  withDescriptor:descriptor
                    dependencies:dependencies];
}

- (void)testThatAssemblyCreatesPresenter {
    // given
    Class targetClass = [RestoreSeedPresenter class];
    NSArray *protocols = @[
                           @protocol(RestoreSeedModuleInput),
                           @protocol(RestoreSeedViewOutput),
                           @protocol(RestoreSeedInteractorOutput)
                           ];
    NSArray *dependencies = @[
                              RamblerSelector(interactor),
                              RamblerSelector(view),
                              RamblerSelector(router)
                              ];
    RamblerTyphoonAssemblyTestsTypeDescriptor *descriptor = [RamblerTyphoonAssemblyTestsTypeDescriptor descriptorWithClass:targetClass
                                                                                                              andProtocols:protocols];

    // when
    id result = [self.assembly presenterRestoreSeed];

    // then
    [self verifyTargetDependency:result
                  withDescriptor:descriptor
                    dependencies:dependencies];
}

- (void)testThatAssemblyCreatesInteractor {
    // given
    Class targetClass = [RestoreSeedInteractor class];
    NSArray *protocols = @[
                           @protocol(RestoreSeedInteractorInput)
                           ];
    NSArray *dependencies = @[
                              RamblerSelector(output)
                              ];
    RamblerTyphoonAssemblyTestsTypeDescriptor *descriptor = [RamblerTyphoonAssemblyTestsTypeDescriptor descriptorWithClass:targetClass
                                                                                                              andProtocols:protocols];
													      
    // when
    id result = [self.assembly interactorRestoreSeed];

    // then
    [self verifyTargetDependency:result
                  withDescriptor:descriptor
                    dependencies:dependencies];
}

- (void)testThatAssemblyCreatesRouter {
    // given
    Class targetClass = [RestoreSeedRouter class];
    NSArray *protocols = @[
                           @protocol(RestoreSeedRouterInput)
                           ];
    NSArray *dependencies = @[
                              RamblerSelector(transitionHandler)
                              ];
    RamblerTyphoonAssemblyTestsTypeDescriptor *descriptor = [RamblerTyphoonAssemblyTestsTypeDescriptor descriptorWithClass:targetClass
                                                                                                              andProtocols:protocols];

    // when
    id result = [self.assembly routerRestoreSeed];

    // then
    [self verifyTargetDependency:result
                  withDescriptor:descriptor
                    dependencies:dependencies];
}

@end
