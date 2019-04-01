//
//  NetworkPlainObject.m
//
//

#import "NetworkPlainObject.h"

@implementation NetworkPlainObject

- (BlockchainNetworkType) network {
  return [self.chainID longLongValue];
}

@end
