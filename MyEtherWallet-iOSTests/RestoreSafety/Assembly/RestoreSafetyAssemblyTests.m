//
//  RestoreSafetyAssemblyTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 18/02/2019.
//  Copyright © 2019 MyEtherWallet, Inc.. All rights reserved.
//

@import RamblerTyphoonUtils.AssemblyTesting;
@import Typhoon;

#import "RestoreSafetyAssembly.h"
#import "RestoreSafetyAssembly_Testable.h"

#import "RestoreSafetyViewController.h"
#import "RestoreSafetyPresenter.h"
#import "RestoreSafetyInteractor.h"
#import "RestoreSafetyRouter.h"

@interface RestoreSafetyAssemblyTests : RamblerTyphoonAssemblyTests

@property (nonatomic, strong) RestoreSafetyAssembly *assembly;

@end

@implementation RestoreSafetyAssemblyTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.assembly = [[RestoreSafetyAssembly alloc] init];
    [self.assembly activate];
}

- (void)tearDown {
    self.assembly = nil;

    [super tearDown];
}

#pragma mark - Assembly tests

- (void)testThatAssemblyCreatesViewController {
    // given
    Class targetClass = [RestoreSafetyViewController class];
    NSArray *protocols = @[
                           @protocol(RestoreSafetyViewInput)
                           ];
    NSArray *dependencies = @[
                              RamblerSelector(output)
                              ];
    RamblerTyphoonAssemblyTestsTypeDescriptor *descriptor = [RamblerTyphoonAssemblyTestsTypeDescriptor descriptorWithClass:targetClass
                                                                                                              andProtocols:protocols];

    // when
    id result = [self.assembly viewRestoreSafety];

    // then
    [self verifyTargetDependency:result
                  withDescriptor:descriptor
                    dependencies:dependencies];
}

- (void)testThatAssemblyCreatesPresenter {
    // given
    Class targetClass = [RestoreSafetyPresenter class];
    NSArray *protocols = @[
                           @protocol(RestoreSafetyModuleInput),
                           @protocol(RestoreSafetyViewOutput),
                           @protocol(RestoreSafetyInteractorOutput)
                           ];
    NSArray *dependencies = @[
                              RamblerSelector(interactor),
                              RamblerSelector(view),
                              RamblerSelector(router)
                              ];
    RamblerTyphoonAssemblyTestsTypeDescriptor *descriptor = [RamblerTyphoonAssemblyTestsTypeDescriptor descriptorWithClass:targetClass
                                                                                                              andProtocols:protocols];

    // when
    id result = [self.assembly presenterRestoreSafety];

    // then
    [self verifyTargetDependency:result
                  withDescriptor:descriptor
                    dependencies:dependencies];
}

- (void)testThatAssemblyCreatesInteractor {
    // given
    Class targetClass = [RestoreSafetyInteractor class];
    NSArray *protocols = @[
                           @protocol(RestoreSafetyInteractorInput)
                           ];
    NSArray *dependencies = @[
                              RamblerSelector(output)
                              ];
    RamblerTyphoonAssemblyTestsTypeDescriptor *descriptor = [RamblerTyphoonAssemblyTestsTypeDescriptor descriptorWithClass:targetClass
                                                                                                              andProtocols:protocols];
													      
    // when
    id result = [self.assembly interactorRestoreSafety];

    // then
    [self verifyTargetDependency:result
                  withDescriptor:descriptor
                    dependencies:dependencies];
}

- (void)testThatAssemblyCreatesRouter {
    // given
    Class targetClass = [RestoreSafetyRouter class];
    NSArray *protocols = @[
                           @protocol(RestoreSafetyRouterInput)
                           ];
    NSArray *dependencies = @[
                              RamblerSelector(transitionHandler)
                              ];
    RamblerTyphoonAssemblyTestsTypeDescriptor *descriptor = [RamblerTyphoonAssemblyTestsTypeDescriptor descriptorWithClass:targetClass
                                                                                                              andProtocols:protocols];

    // when
    id result = [self.assembly routerRestoreSafety];

    // then
    [self verifyTargetDependency:result
                  withDescriptor:descriptor
                    dependencies:dependencies];
}

@end
