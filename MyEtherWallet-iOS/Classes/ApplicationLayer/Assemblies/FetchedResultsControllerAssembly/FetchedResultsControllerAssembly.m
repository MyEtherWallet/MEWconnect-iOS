//
//  FetchedResultsControllerAssembly.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 22/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "FetchedResultsControllerAssembly.h"
#import "PonsomizerAssembly.h"

#import "CacheTrackerImplementation.h"

@implementation FetchedResultsControllerAssembly

- (id <CacheTracker>) cacheTrackerWithDelegate:(id<CacheTrackerDelegate>)delegate {
  return [TyphoonDefinition withClass:[CacheTrackerImplementation class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(ponsomizer)
                                                with:[self.ponsomizerAssembly ponsomizer]];
                          [definition injectProperty:@selector(delegate)
                                                with:delegate];
                        }];
}

@end
