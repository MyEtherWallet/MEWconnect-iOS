//
//  NSData+SECP256K1.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 24/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import secp256k1_swift;

#import "NSData+SECP256K1.h"

@implementation NSData (SECP256K1)

- (NSData *) signWithPrivateKeyData:(NSData *)privateKeyData {
  secp256k1_context *context = secp256k1_context_create(SECP256K1_CONTEXT_SIGN);
  
  const unsigned char *prvKey = (const unsigned char *)privateKeyData.bytes;
  const unsigned char *msg = (const unsigned char *)self.bytes;
  
  unsigned char *siga = malloc(65);
  secp256k1_ecdsa_recoverable_signature sig;
  int result = secp256k1_ecdsa_sign_recoverable(context, &sig, msg, prvKey, NULL, NULL);
  if (result != 1) {
    free(siga);
    return nil;
  }
  
  int recId = 0;
  result = secp256k1_ecdsa_recoverable_signature_serialize_compact(context, siga, &recId, &sig);
  
  if (result != 1) {
    free(siga);
    return nil;
  }
  
  secp256k1_context_destroy(context);
  siga[64] = recId + 27;
  
  NSMutableData *data = [[NSMutableData alloc] init];
  
  [data appendBytes:&siga[64] length:sizeof(unsigned char)];
  [data appendBytes:siga length:sizeof(unsigned char) * 64];
  free(siga);
  return data;
}
@end
