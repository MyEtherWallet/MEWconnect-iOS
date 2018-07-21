//
//  BuyEtherWebAssemblyTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 05/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import RamblerTyphoonUtils.AssemblyTesting;
@import Typhoon;

#import "BuyEtherWebAssembly.h"
#import "BuyEtherWebAssembly_Testable.h"

#import "BuyEtherWebViewController.h"
#import "BuyEtherWebPresenter.h"
#import "BuyEtherWebInteractor.h"
#import "BuyEtherWebRouter.h"

@interface BuyEtherWebAssemblyTests : RamblerTyphoonAssemblyTests

@property (nonatomic, strong) BuyEtherWebAssembly *assembly;

@end

@implementation BuyEtherWebAssemblyTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.assembly = [[BuyEtherWebAssembly alloc] init];
    [self.assembly activate];
}

- (void)tearDown {
    self.assembly = nil;

    [super tearDown];
}

#pragma mark - Assembly tests

- (void)testThatAssemblyCreatesViewController {
    // given
    Class targetClass = [BuyEtherWebViewController class];
    NSArray *protocols = @[
                           @protocol(BuyEtherWebViewInput)
                           ];
    NSArray *dependencies = @[
                              RamblerSelector(output)
                              ];
    RamblerTyphoonAssemblyTestsTypeDescriptor *descriptor = [RamblerTyphoonAssemblyTestsTypeDescriptor descriptorWithClass:targetClass
                                                                                                              andProtocols:protocols];

    // when
    id result = [self.assembly viewBuyEtherWeb];

    // then
    [self verifyTargetDependency:result
                  withDescriptor:descriptor
                    dependencies:dependencies];
}

- (void)testThatAssemblyCreatesPresenter {
    // given
    Class targetClass = [BuyEtherWebPresenter class];
    NSArray *protocols = @[
                           @protocol(BuyEtherWebModuleInput),
                           @protocol(BuyEtherWebViewOutput),
                           @protocol(BuyEtherWebInteractorOutput)
                           ];
    NSArray *dependencies = @[
                              RamblerSelector(interactor),
                              RamblerSelector(view),
                              RamblerSelector(router)
                              ];
    RamblerTyphoonAssemblyTestsTypeDescriptor *descriptor = [RamblerTyphoonAssemblyTestsTypeDescriptor descriptorWithClass:targetClass
                                                                                                              andProtocols:protocols];

    // when
    id result = [self.assembly presenterBuyEtherWeb];

    // then
    [self verifyTargetDependency:result
                  withDescriptor:descriptor
                    dependencies:dependencies];
}

- (void)testThatAssemblyCreatesInteractor {
    // given
    Class targetClass = [BuyEtherWebInteractor class];
    NSArray *protocols = @[
                           @protocol(BuyEtherWebInteractorInput)
                           ];
    NSArray *dependencies = @[
                              RamblerSelector(output)
                              ];
    RamblerTyphoonAssemblyTestsTypeDescriptor *descriptor = [RamblerTyphoonAssemblyTestsTypeDescriptor descriptorWithClass:targetClass
                                                                                                              andProtocols:protocols];
													      
    // when
    id result = [self.assembly interactorBuyEtherWeb];

    // then
    [self verifyTargetDependency:result
                  withDescriptor:descriptor
                    dependencies:dependencies];
}

- (void)testThatAssemblyCreatesRouter {
    // given
    Class targetClass = [BuyEtherWebRouter class];
    NSArray *protocols = @[
                           @protocol(BuyEtherWebRouterInput)
                           ];
    NSArray *dependencies = @[
                              RamblerSelector(transitionHandler)
                              ];
    RamblerTyphoonAssemblyTestsTypeDescriptor *descriptor = [RamblerTyphoonAssemblyTestsTypeDescriptor descriptorWithClass:targetClass
                                                                                                              andProtocols:protocols];

    // when
    id result = [self.assembly routerBuyEtherWeb];

    // then
    [self verifyTargetDependency:result
                  withDescriptor:descriptor
                    dependencies:dependencies];
}

@end
