//
//  MEWcryptoMessage.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 17/06/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "MEWcryptoMessage.h"

#import "NSArray+Data.h"
#import "NSData+ArrayBuffer.h"

static NSString *const kIvRepresentationKey                  = @"iv";
static NSString *const kEphemPublicKeyRepresentationKey      = @"ephemPublicKey";
static NSString *const kCipherTextKeyRepresentationKey       = @"ciphertext";
static NSString *const kMacKeyRepresentationKey              = @"mac";
static NSString *const kDataKeyRepresentationKey             = @"data";

@interface MEWcryptoMessage ()
@property (nonatomic, strong) NSData *iv;
@property (nonatomic, strong) NSData *ephemPublicKey;
@property (nonatomic, strong) NSData *cipher;
@property (nonatomic, strong) NSData *mac;
@end

@implementation MEWcryptoMessage
+ (instancetype) messageWithIV:(NSData *)iv ephemPublicKey:(NSData *)ephemPublicKey cipher:(NSData *)cipher mac:(NSData *)mac {
  MEWcryptoMessage *message = [[[self class] alloc] init];
  message.iv = iv;
  message.ephemPublicKey = ephemPublicKey;
  message.cipher = cipher;
  message.mac = mac;
  return message;
}

+ (instancetype) messageWithIVArray:(NSArray <NSNumber *> *)ivArray ephemPublicKeyArray:(NSArray <NSNumber *> *)ephemPublicKeyArray cipherArray:(NSArray <NSNumber *> *)cipherArray macArray:(NSArray <NSNumber *> *)macArray {
  MEWcryptoMessage *message = [[[self class] alloc] init];
  message.iv = [ivArray convertToData];
  message.ephemPublicKey = [ephemPublicKeyArray convertToData];
  message.cipher = [cipherArray convertToData];
  message.mac = [macArray convertToData];
  return message;
}

+ (instancetype) messageWithRepresentation:(NSDictionary *)representation {
  return [self messageWithIVArray:representation[kIvRepresentationKey][kDataKeyRepresentationKey]
              ephemPublicKeyArray:representation[kEphemPublicKeyRepresentationKey][kDataKeyRepresentationKey]
                      cipherArray:representation[kCipherTextKeyRepresentationKey][kDataKeyRepresentationKey]
                         macArray:representation[kMacKeyRepresentationKey][kDataKeyRepresentationKey]];
}

- (BOOL)isValid {
  return self.iv && self.ephemPublicKey && self.cipher && self.mac;
}

- (NSDictionary *) representation {
  if ([self isValid]) {
    return @{kCipherTextKeyRepresentationKey    : [self.cipher convertToBuffer],
             kEphemPublicKeyRepresentationKey   : [self.ephemPublicKey convertToBuffer],
             kIvRepresentationKey               : [self.iv convertToBuffer],
             kMacKeyRepresentationKey           : [self.mac convertToBuffer]};
  }
  return nil;
}

@end
